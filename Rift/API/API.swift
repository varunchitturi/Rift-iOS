//
//  API.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import URLEncodedForm

struct API {
    
    static let authenticationRequestManager = RequestManager(sessionType: .authentication)
    static let defaultRequestManager = RequestManager(sessionType: .data)
    
    enum APIError: LocalizedError {
        
        case invalidUser
        case invalidData
        case invalidRequest
        case invalidLocale
        case responseError(HTTPURLResponse.Status)
        case invalidCookies
        
        var localizedDescription: String {
            switch self {
            case .invalidUser:
                return "Invalid user found during authentication process."
            case .invalidData:
                return "No or invalid data was found in the API response."
            case .invalidRequest:
                return "An invalid request was made. Please check your request paramaters."
            case .invalidLocale:
                return "There is no associated district found with this request."
            case .responseError(let status):
                return "Your request could not be completed. HTTP status: \(status.description)"
            case .invalidCookies:
                return "No or invalid cookies were found in the API response"
            }
        }
        
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
    
    class RequestManager {
        
        init(sessionType: SessionType) {
            switch sessionType {
            case .data:
                urlSession = URLSession(configuration: .dataLoad)
            case .authentication:
                urlSession = URLSession(configuration: .authentication)
            }
        }
        
        enum SessionType {
            case data
            case authentication
        }
        
        private var urlSession: URLSession
        
        private func evaluateResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ())  {
            if let error = (error ?? APIError(response: response)) {
                completion(.failure(error))
            }
            else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            }
            else {
                completion(.failure(APIError.invalidData))
            }
        }

        func get(endpoint: String, locale: Locale? = nil, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
            guard let locale = (locale ?? PersistentLocale.getLocale()) else {
                return completion(.failure(APIError.invalidLocale))
            }
            
            get(url: locale.districtBaseURL.appendingPathComponent(endpoint), completion: completion)
        }
        
        func get(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
            urlSession.dataTask(with: url) { data, response, error in
                self.evaluateResponse(data, response, error, completion)
            }
            .resume()
        }
        
        
        
        func post<T>(endpoint: String, data: T, encodeType: URLRequest.ContentType, locale: Locale? = nil, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) where T: Encodable {
            guard let locale = (locale ?? PersistentLocale.getLocale()) else {
                return completion(.failure(APIError.invalidLocale))
            }
            
            var urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(endpoint))
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
                    self.evaluateResponse(data, response, error, completion)
                }
                .resume()
            }
            catch {
                completion(.failure(error))
            }
        }

        func resetSession() {
            urlSession.invalidateAndCancel()
            urlSession = URLSession(configuration: urlSession.configuration)
            urlSession.configuration.httpCookieStorage?.clearCookies()
        }
    }
}
