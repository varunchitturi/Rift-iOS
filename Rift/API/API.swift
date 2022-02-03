//
//  API.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import URLEncodedForm

struct API {
    
    /// The `RequestManager` for all authentication related network requests
    static let authenticationRequestManager = RequestManager(sessionConfiguration: .authentication)
    
    /// The default `RequestManager` for network requests
    static let defaultRequestManager = RequestManager(sessionConfiguration: .dataLoad)
    
    /// An error produced when making an API based network call
    enum APIError: LocalizedError {
        
        case invalidUser
        case invalidData
        case invalidRequest
        case invalidLocale
        case responseError(HTTPURLResponse.Status)
        case invalidCookies
        case invalidRedirect
        
        var localizedDescription: String {
            switch self {
            case .invalidUser:
                return "Invalid user found during authentication process."
            case .invalidData:
                return "No or invalid data was found in the API response."
            case .invalidRequest:
                return "An invalid request was made. Please check your request parameters."
            case .invalidLocale:
                return "There is no associated district found with this request."
            case .responseError(let status):
                return "Your request could not be completed. HTTP status: \(status.description)"
            case .invalidCookies:
                return "No or invalid cookies were found in the API response"
            case .invalidRedirect:
                return "API redirected when it was not supposed to"
            }
        }
        
        /// Creates an APIError from a URLResponse based on its status
        init?(response: URLResponse?) {
            guard let response = response as? HTTPURLResponse else {
                return nil
            }
            switch response.status {
            case .success, .moved, .found, .notModified:
                return nil
            default:
                self = .responseError(response.status)
            }
        }
       
    }
    
    /// An abstraction over all network calls to the API. Creates get and post requests and automatically handles network-based configuration
    /// such as cookie handling, data decoding, and error handling.
    class RequestManager {
        
        /// Creates a `RequestManager` to make API calls with
        /// - Parameter sessionConfiguration: the `URLSessionConfiguration`  you want to use for the network requests
        init(sessionConfiguration: URLSessionConfiguration) {
            urlSession = URLSession(configuration: sessionConfiguration)
        }
        
        
        /// The URLSession that this `RequestManger` uses to make network requests
        private var urlSession: URLSession
        
        /// Handles a response from a `URLSessionDataTask`
        /// - Parameters:
        ///   - requestMethod: The HTTP method for the network request
        ///   - requestURL: The` URL` that the network request is being made to
        ///   - data: The data found in the network response
        ///   - response: A `URLResponse` found in the the network response
        ///   - error: An error found in the network response
        /// - Returns: A `Result` that is successful if data can be decoded and no errors have been found
        /// - Note: An `APIError.invalidRedirect` is thrown if requestURL doesn't match the responseURL. API calls for data should not be redirected.
        private func evaluateResponse(requestMethod: URLRequest.HTTPMethod, _ requestURL: URL, _ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<(Data, HTTPURLResponse), Error>  {
            if let error = (error ?? APIError(response: response)) {
                return .failure(error)
            }
            else if let data = data, let response = response as? HTTPURLResponse {
                switch requestMethod {
                case .get:
                    if let responseURL = response.url?.removingQueries(),
                       let requestURL = requestURL.removingQueries(),
                       responseURL == requestURL {
                        return .success((data, response))
                    }
                    else {
                        return .failure(APIError.invalidRedirect)
                    }
                default:
                    return .success((data, response))
                }
            }
            else {
                return .failure(APIError.invalidData)
            }
        }
        
        /// API call to get data
        /// - Parameters:
        ///   - endpoint: The endpoint you want to make the `GET` call to
        ///   - locale: A locale that provides the district URL to make the call to
        ///   - retryAuthentication: A `Bool` telling whether the request should re-authenticate and retry if the authentication credentials have expired
        ///   - completion: Completion function
        func get(endpoint: String, locale: Locale? = nil, retryAuthentication: Bool = true, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
            guard let locale = (locale ?? PersistentLocale.getLocale()) else {
                return completion(.failure(APIError.invalidLocale))
            }
            
            get(url: locale.districtBaseURL.appendingPathComponent(endpoint), retryAuthentication: retryAuthentication, completion: completion)
        }
        
        /// API call to get data
        /// - Parameters:
        ///   - url: The `URL` you want to make the `GET` call to
        ///   - retryAuthentication: A `Bool` telling whether the request should re-authenticate and retry if the authentication credentials have expired
        ///   - completion: Completion function
        func get(url: URL, retryAuthentication: Bool = true, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
            urlSession.dataTask(with: url) { data, response, error in
                let result = self.evaluateResponse(requestMethod: .get, url, data, response, error)
                switch result {
                case .success(let successResult) :
                    completion(.success(successResult))
                case .failure(let error):
                    switch error {
                    case APIError.responseError, APIError.invalidRedirect:
                        if retryAuthentication {
                            API.Authentication.attemptCookieAuthentication { result in
                                switch result {
                                case .success(let authenticationState) where authenticationState == .authenticated:
                                    self.urlSession.dataTask(with: url) { data, response, error in
                                        completion(self.evaluateResponse(requestMethod: .get, url, data, response, error))
                                    }
                                    .resume()
                                default:
                                    completion(.failure(error))
                                }
                            }
                        }
                        else {
                            completion(.failure(error))
                        }
                    default:
                        completion(.failure(error))
                    }
                }
            }
            .resume()
        }
        
        
        
        
        /// API call to post data
        /// - Parameters:
        ///   - endpoint: The endpoint you want to make the `POST` call to
        ///   - data: An encodable type that is encoded to be sent in the `POST` request
        ///   - encodeType: Specifies the format that the data is encoded in
        ///   - locale: A locale that provides the district URL to make the call to
        ///   - completion: Completion function
        func post<T>(endpoint: String, data: T, encodeType: URLRequest.ContentType, locale: Locale? = nil, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) where T: Encodable {
            guard let locale = (locale ?? PersistentLocale.getLocale()) else {
                return completion(.failure(APIError.invalidLocale))
            }
            
            post(url: locale.districtBaseURL.appendingPathComponent(endpoint), data: data, encodeType: encodeType, completion: completion)
        }
        
        /// API call to post data
        /// - Parameters:
        ///   - url: The `URL` you want to make the `POST` call to
        ///   - data: An encodable type that is encoded to be sent in the `POST` request
        ///   - encodeType: Specifies the format that the data is encoded in
        ///   - completion: Completion function
        func post<T>(url: URL, data: T, encodeType: URLRequest.ContentType, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) where T: Encodable {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
             
            do {
                switch encodeType {
                case .form:
                    urlRequest.httpBody = try URLEncodedFormEncoder().encode(data)
                    urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
                case .json:
                    urlRequest.httpBody = try JSONEncoder().encode(data)
                    urlRequest.setValue(URLRequest.ContentType.json.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
                }
                
                urlSession.dataTask(with: urlRequest) { data, response, error in
                    completion(self.evaluateResponse(requestMethod: .post, url, data, response, error))
                }
                .resume()
            }
            catch {
                completion(.failure(error))
            }
        }
        
        /// Cancels and invalidates any active URLSession Data Tasks, clears all cookies in shared storage,
        /// and creates a new `URLSession` with the current configuration
        func resetSession() {
            urlSession.invalidateAndCancel()
            urlSession = URLSession(configuration: urlSession.configuration)
            urlSession.configuration.httpCookieStorage?.clearCookies()
        }
    }
}
