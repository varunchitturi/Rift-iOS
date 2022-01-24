//
//  AuthenticationAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation
import UIKit
import URLEncodedForm
import SwiftSoup

extension API {
    struct Authentication {
        
        private static var defaultURLSession = URLSession(configuration: .authentication)
        
        
        enum Cookie: CaseIterable {
            case jsession
            case sis
            case appName
            case portalApp
            case persistent
            
            var name: String {
                switch self {
                case .jsession:
                    return "JSESSIONID"
                case .appName:
                    return "appName"
                case .sis:
                    return "sis-cookie"
                case .persistent:
                    return "persistent_cookie"
                case .portalApp:
                    return "portalApp"
                }
            }
            
            var isRequired: Bool {
                switch self {
                case .jsession:
                    return true
                case .appName:
                    return true
                case .sis:
                    return true
                case .persistent:
                    return false
                case .portalApp:
                    return true
                }
            }
        }
        
        static let successPath = "nav-wrapper"

        private enum Endpoint {
            static let portalConfig = "resources/fremont/portal/config"
            static let provisionalCookies = "mobile/hybridAppUtil.jsp"
            static let persistenceUpdate = "resources/portal/hybrid-device/update"
            static let logOut = "logoff.jsp"
            static let authorization = "verify.jsp"
        }
        
        static func getProvisionalCookies(for locale: Locale, completion: @escaping (Error?) -> ()) {
            
            Authentication.defaultURLSession.invalidateAndCancel()
            Authentication.defaultURLSession = URLSession(configuration: .authentication)
            HTTPCookieStorage.shared.clearCookies()
         
            getPortalConfig(for: locale) { error in
                if let error = error {
                    completion(error)
                }
                else {
                    Authentication.defaultURLSession.dataTask(with: locale.logInURL) { data, response, error in
                        if let error = (error ?? APIError(response: response)) {
                            completion(error)
                        }
                        else {
                            let provisionalCookieConfiguration = ProvisionalCookieConfiguration(appName: locale.districtAppName)
                            var urlRequest =  URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.provisionalCookies))
                            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
                            urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
                            let formEncoder = URLEncodedFormEncoder()
                            do {
                                urlRequest.httpBody = try formEncoder.encode(provisionalCookieConfiguration)
                                Authentication.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                                    if let error = (error ?? APIError(response: response)) {
                                        completion(error)
                                    }
                                    else {
                                        getProvisions(for: locale) { error in
                                            if let error = error {
                                                completion(error)
                                            }
                                            else {
                                                completion(nil)
                                            }
                                        }
                                    }
                                }.resume()
                            }
                            catch {
                                completion(error)
                            }
                        }
                    }.resume()
                }
            }
        }
        
        private static func getPortalConfig(for locale: Locale, completion: @escaping (Error?) -> ()) {
            
            let url = locale.districtBaseURL.appendingPathComponent(Endpoint.portalConfig)
            Authentication.defaultURLSession.dataTask(with: url) { data, response, error in
                if let error = (error ?? APIError(response: response)) {
                    completion(error)
                }
                else {
                    completion(nil)
                }
            }.resume()
        }
        
        private static func getProvisions(for locale: Locale, completion: @escaping (Error?) -> ()) {
            
            let url = locale.districtBaseURL.appendingPathComponent(Endpoint.provisionalCookies)
            
            Authentication.defaultURLSession.dataTask(with: url) { data, response, error in
                if let error = (error ?? APIError(response: response)) {
                    completion(error)
                }
                else if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == API.Authentication.Cookie.sis.name}) == true {
                    completion(nil)
                }
                else {
                    completion(APIError.invalidCookies)
                }
            }.resume()
        }
        
        static func getLogInSSO(for locale: Locale, completion: @escaping (Result<URL?, Error>)  -> ())  {
            Authentication.defaultURLSession.dataTask(with: locale.logInURL) { data, response, error in
                do {
                    if let error = (error ?? APIError(response: response)) {
                        throw error
                    }
                    guard let data = data, let html = String(data: data, encoding: .ascii) else {
                        throw APIError.invalidData
                    }
                    let htmlDOM = try SwiftSoup.parse(html)
                    let samlURLString: String = (try? htmlDOM.getElementById("samlLoginLink")?.attr("href")) ?? ""
                    completion(.success(URL(string: samlURLString)))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
        
        static func usePersistence(locale: Locale? = nil, _ isPersistent: Bool, completion: @escaping (Error?) -> ()) {
            
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(APIError.invalidLocale)
                return
                
            }
            
            let persistenceUpdateURL = locale.districtBaseURL.appendingPathComponent(Endpoint.persistenceUpdate)
            
            var urlRequest =  URLRequest(url: persistenceUpdateURL)
            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
            urlRequest.setValue(URLRequest.ContentType.json.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
            
            let persistenceUpdateConfiguration = PersistenceUpdateConfiguration()
            
            do {
                let jsonEncoder = JSONEncoder()
                urlRequest.httpBody = try jsonEncoder.encode(persistenceUpdateConfiguration)
                Authentication.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                    if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true {
                        completion(nil)
                    }
                    else {
                        completion(API.APIError.invalidCookies)
                    }
                }
                .resume()
            }
            catch {
                completion(error)
            }
        }
        
        static func attemptCookieAuthentication(completion: @escaping (Result<ApplicationModel.AuthenticationState, Error>) -> ()) {
            if let locale = PersistentLocale.getLocale(),
               HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true,
            let requestBody = try? URLEncodedFormEncoder().encode(ProvisionalCookieConfiguration(appName: locale.districtAppName)) {
                var urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.provisionalCookies))
                urlRequest.httpBody = requestBody
                urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
                URLSession(configuration: .authentication).dataTask(with: urlRequest) { data, response, error in
                    if let response = response as? HTTPURLResponse, response.status == .success {
                        completion(.success(.authenticated))
                    }
                    else if let error = (error ?? APIError(response: response))  {
                        completion(.failure(error))
                    }
                    else {
                        completion(.success(.unauthenticated))
                    }
                }.resume()
            }
            else {
                completion(.success(.authenticated))
            }
        }
        
        static func attemptCredentialAuthentication(locale: Locale? = nil, credentials: Credentials, completion: @escaping (Result<ApplicationModel.AuthenticationState, Error>) -> ()) {
            guard let locale = locale ?? PersistentLocale.getLocale(),
                  let appCookie = HTTPCookie(properties: [.name : Authentication.Cookie.appName.name,
                                                          .value : locale.districtAppName,
                                                          .domain: locale.districtBaseURL.host?.description ?? "",
                                                          .path: "/"
                                                         ]) else {

                return completion(.failure(APIError.invalidLocale))
            }
            // TODO: don't let user turn on remember me if there is no persistent cookie available
            HTTPCookieStorage.shared.setCookie(appCookie)
            var urlRequest =  URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.authorization))
            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
            urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
            
            let formEncoder = URLEncodedFormEncoder()
            do {
                urlRequest.httpBody = try formEncoder.encode(credentials)
                Authentication.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                    if let error = (error ?? APIError(response: response)) {
                        completion(.failure(error))
                    }
                    else {
                        if response?.url?.lastPathComponent == Authentication.successPath {
                            completion(.success(.authenticated))
                        }
                        else {
                            completion(.success(.unauthenticated))
                        }
                    }
                }
                .resume()
            }
            catch {
                completion(.failure(error))
            }
            
        }
        static func logOut(locale: Locale? = nil, completion: @escaping (Error?) -> ()) {
            guard let locale = locale ?? PersistentLocale.getLocale() else { return }
            let query = URLQueryItem(name: "app", value: ApplicationModel.appType.rawValue)
            guard let url = locale.districtBaseURL
                    .appendingPathComponent(Endpoint.logOut)
                .appendingQueryItems([query])
            else {
                completion(APIError.invalidLocale)
                return
            }
            let urlRequest = URLRequest(url: url)
            // TODO: explain why we use shared here
            URLSession.shared.dataTask(with: urlRequest) { _, response, error in
                if let error = (error ?? APIError(response: response)) {
                    completion(error)
                    return
                }
                else {
                    completion(nil)
                }
            }.resume()
        }
        
        private struct ProvisionalCookieConfiguration: Encodable {
            
            init(appName: String) {
                self.appName = appName
            }
            
            static let bootstrappedCode = "1"
            // I think that this is the notification registration token!
            static let registrationToken = UUID().uuidString
            static let deviceID = UIDevice.currentDeviceID
            
            let bootstrapped = ProvisionalCookieConfiguration.bootstrappedCode
            let registrationToken = ProvisionalCookieConfiguration.registrationToken
            let deviceID = ProvisionalCookieConfiguration.deviceID
            let deviceModel = UIDevice.current.model
            let deviceType = UIDevice.current.systemVersion
            let appType = ApplicationModel.appType.description
            let appVersion = Bundle.main.version
            let systemVersion = UIDevice.current.systemVersion
            let appName: String
        }
        
        private struct PersistenceUpdateConfiguration: Encodable {
            let registrationToken = ProvisionalCookieConfiguration.registrationToken
            let deviceType = UIDevice.current.systemVersion
            let deviceModel = UIDevice.current.model
            let appVersion = Bundle.main.version
            let systemVersion = UIDevice.current.systemVersion
            let keepMeLoggedIn = true
            let deviceID = ProvisionalCookieConfiguration.deviceID
        }
        
        struct Credentials: Codable {
            let username: String
            let password: String
        }
        
    }
}
