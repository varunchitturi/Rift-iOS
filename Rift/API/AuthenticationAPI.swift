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
        
        private static var urlSession = URLSession(configuration: .authentication)
        
        
        enum Cookie: CaseIterable {
            case jsession
            case sis
            case appName
            case portalApp
            case persistent
            
            var name: String {
                switch self {
                case .jsession:
                    return "JSESSION"
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
            static let provisionCookies = "mobile/hybridAppUtil.jsp"
            static let persistenceUpdate = "resources/portal/hybrid-device/update"
            static let logOut = "logoff.jsp"
            static let authorization = "verify.jsp"
        }
        
        enum AuthenticationError: Error {
            case failure
        }
        
        static func getProvisionalCookies(for locale: Locale, completion: @escaping (Error?) -> ()) {
            Authentication.urlSession = URLSession.reset(from: Authentication.urlSession)
            HTTPCookieStorage.shared.clearCookies()
            let provisionalCookieConfiguration = ProvisionalCookieConfiguration(appName: locale.districtAppName)
            var urlRequest =  URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.provisionCookies))
            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
            urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
            let formEncoder = URLEncodedFormEncoder()
            do {
                urlRequest.httpBody = try formEncoder.encode(provisionalCookieConfiguration)
                Authentication.urlSession.dataTask(with: urlRequest) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(error)
                        }
                        else {
                            completion(nil)
                        }
                    }
                }
                .resume()
            }
            catch {
                completion(error)
            }
        }
        
        static func getLogInSSO(for locale: Locale, completion: @escaping (Result<URL?, Error>)  -> ())  {
            
            var loginURL: URL {
                switch ApplicationModel.appType {
                case .student:
                    return locale.studentLogInURL
                case .parent:
                    return locale.parentLogInURL
                case .staff:
                    return locale.staffLogInURL
                }
                
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let html = try String(contentsOf: loginURL)
                    let htmlDOM = try SwiftSoup.parse(html)
                    let samlURLString: String = (try? htmlDOM.getElementById("samlLoginLink")?.attr("href")) ?? ""
                    DispatchQueue.main.async {
                        completion(.success(URL(string: samlURLString)))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
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
                Authentication.urlSession.dataTask(with: urlRequest) { data, response, error in
                    if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true {
                        completion(nil)
                    }
                    else {
                        completion(Authentication.AuthenticationError.failure)
                    }
                }
                .resume()
            }
            catch {
                completion(error)
            }
        }
        
        static func attemptAuthentication(completion: @escaping (ApplicationModel.AuthenticationState) -> ()) {
            // TODO: fix context accessed for persistent container Model with no stores loaded CoreData: warning:  View context accessed for persistent container Model with no stores loaded
            if let locale = PersistentLocale.getLocale(),
               HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true,
            let requestBody = try? URLEncodedFormEncoder().encode(ProvisionalCookieConfiguration(appName: locale.districtAppName)) {
                var urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.provisionCookies))
                urlRequest.httpBody = requestBody
                urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
                URLSession(configuration: .authentication).dataTask(with: urlRequest) { data, response, error in
                    if let response = response as? HTTPURLResponse, response.status == .success {
                        completion(.authenticated)
                    }
                    else  {
                        completion(.unauthenticated)
                    }
                }.resume()
            }
            else {
                completion(.unauthenticated)
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
            URLSession.shared.dataTask(with: urlRequest) { _, _, error in
                if let error = error {
                    completion(error)
                    return
                    // TODO: better error handling here
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
        
    }
}
