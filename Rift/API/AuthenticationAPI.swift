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
    
    /// API for all authentication based requests
    struct Authentication {
        
        /// Cookie used in authentication
        enum Cookie: CaseIterable {
            case jsession
            case sis
            case appName
            case portalApp
            case persistent
            
            /// The name of the cookie
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
            
            /// Gives if the cookie is needed to make API calls
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
            
            func getHTTPCookie(in locale: Locale) -> HTTPCookie? {
                return HTTPCookie(properties: [.name : self.name,
                                               .value : locale.districtAppName,
                                               .domain: locale.districtBaseURL.host?.description ?? "",
                                               .path: "/"])
            }
        }
        
        /// A path included in the `URL` that is given after authentication success
        /// - If a SSO authentication page redirects to a `URL` that includes this path, then you know that the user has been authenticated
        static let successPath = "nav-wrapper"
        
        /// Collection of endpoints used in authentication
        private enum Endpoint {
            
            /// A path for authentication resources
            static let resources = "resources/"
            
            /// Endpoint to get cookies for portal configuration
            static let portalConfig = "portal/config"
            
            /// Endpoint to get cookies for provisioning mobile devices
            static let provisionalCookies = "mobile/hybridAppUtil.jsp"
            
            /// Endpoint to get a `persistent-cookie`
            static let persistenceUpdate = "resources/portal/hybrid-device/update"
            
            /// Endpoint used to logoff a user
            static let logOut = "logoff.jsp"
            
            /// Endpoint to post credentials to for credential based authentication
            static let authorization = "verify.jsp"
        }
        
        /// Gets all cookies needed to begin authentication
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        static func getProvisionalCookies(for locale: Locale, completion: @escaping (Error?) -> ()) {
            API.authenticationRequestManager.resetSession {
                getPortalConfig(for: locale) { error in
                    if let error = error {
                        completion(error)
                    }
                    else {
                        API.authenticationRequestManager.get(endpoint: Endpoint.provisionalCookies, locale: locale) { result in
                            switch result {
                            case .success(_):
                                if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == API.Authentication.Cookie.sis.name}) == true {
                                    API.authenticationRequestManager.post(endpoint: Endpoint.provisionalCookies, data: ProvisionalCookieConfiguration(appName: locale.districtAppName), encodeType: .form, locale: locale) { result in
                                        switch result {
                                        case .success(_):
                                            completion(nil)
                                        case .failure(let error):
                                            completion(error)
                                        }
                                    }
                                }
                                else {
                                    completion(APIError.invalidCookies)
                                }
                            case .failure(let error):
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
        
        /// Gets portal configuration cookies
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        private static func getPortalConfig(for locale: Locale, completion: @escaping (Error?) -> ()) {
            let configEndpoint = "\(Endpoint.resources)\(locale.districtAppName)/\(Endpoint.portalConfig)"
            guard let url = locale.districtBaseURL
                .appendingPathComponent(configEndpoint)
                .appendingQueryItems([.init(name: "_t", value: Date.now.timeIntervalSince1970.description)]) else {
                    return completion(APIError.invalidRequest)
                }
            API.authenticationRequestManager.get(url: url, retryAuthentication: false) { result in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        /// Gets the SSO login link for a district if one exists
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        static func getLogInSSO(for locale: Locale, completion: @escaping (Result<URL?, Error>)  -> ())  {
            API.authenticationRequestManager.get(url: locale.logInURL) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        guard let html = String(data: data, encoding: .ascii) else {
                            throw APIError.invalidData
                        }
                        let htmlDOM = try SwiftSoup.parse(html)
                        let samlURLString: String = (try? htmlDOM.getElementById("samlLoginLink")?.attr("href")) ?? ""
                        completion(.success(URL(string: samlURLString)))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        /// Tries to obtain a `persistent-cookie`
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        /// - Note: The user must be currently logged in and have a valid session cookies in order to obtain a `persistent-cookie`
        static func usePersistence(locale: Locale? = nil, completion: @escaping (Error?) -> ()) {
            
            let config = PersistenceUpdateConfiguration()
            
            API.authenticationRequestManager.post(endpoint: Endpoint.persistenceUpdate, data: config, encodeType: .json, locale: locale) { result in
                switch result {
                case .success(_):
                    if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true {
                        API.authenticationRequestManager.post(endpoint: Endpoint.persistenceUpdate, data: config, encodeType: .json, locale: locale) { result in
                            switch result {
                            case .success(_):
                                completion(nil)
                            case .failure(let error):
                                completion(error)
                            }
                        }
                    }
                    else {
                        completion(API.APIError.invalidCookies)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        /// Tries to authenticate a user using an existing `persistent-cookie`
        /// - Parameter completion: Completion function
        static func attemptCookieAuthentication(completion: @escaping (Result<ApplicationModel.AuthenticationState, Error>) -> ()) {
            if let locale = PersistentLocale.getLocale(),
               HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true {
                
                API.authenticationRequestManager.post(endpoint: Endpoint.provisionalCookies, data: ProvisionalCookieConfiguration(appName: locale.districtAppName), encodeType: .form) { result in
                    switch result {
                    case .success((_, let response)):
                        if response.status == .success {
                            completion(.success(.authenticated))
                        }
                        else {
                            completion(.success(.unauthenticated))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                                
                }
            }
            else {
                completion(.success(.unauthenticated))
            }
        }
        
        /// Tries to authenticate a user using a `Credential`
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - credentials: Credentials for the user
        ///   - completion: Completion function
        static func attemptCredentialAuthentication(locale: Locale, credentials: Credentials, completion: @escaping (Result<ApplicationModel.AuthenticationState, Error>) -> ()) {
            
            guard let appCookie =  Cookie.appName.getHTTPCookie(in: locale) else {
                return completion(.failure(APIError.invalidLocale))
            }
      
            HTTPCookieStorage.shared.setCookie(appCookie)
            
            API.authenticationRequestManager.post(endpoint: Endpoint.authorization, data: credentials, encodeType: .form, locale: locale) { result in
                switch result {
                case .success((_, let response)):
                    if response.url?.lastPathComponent == Authentication.successPath {
                        completion(.success(.authenticated))
                    }
                    else {
                        completion(.success(.unauthenticated))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        /// Logs out the user and invalidates session cookies. If a `persistent-cookie` is being used, it will be invalidated.
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        static func logOut(locale: Locale? = nil, completion: @escaping (Error?) -> ()) {
            guard let locale = locale ?? PersistentLocale.getLocale() else { return completion(APIError.invalidLocale) }
            let query = URLQueryItem(name: "app", value: ApplicationModel.appType.rawValue)
            guard let url = locale.districtBaseURL
                                    .appendingPathComponent(Endpoint.logOut)
                                    .appendingQueryItems([query])
            else {
                return completion(APIError.invalidRequest)
            }
            API.stopPendingTasks()
            API.authenticationRequestManager.get(url: url) { result in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        /// A type that is encoded to obtain provisional cookies
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
        
        /// A type that is encoded in order to obtain a `persistent-cookie`
        private struct PersistenceUpdateConfiguration: Encodable {
            let registrationToken = ProvisionalCookieConfiguration.registrationToken
            let deviceType = UIDevice.current.systemVersion
            let deviceModel = UIDevice.current.model
            let appVersion = Bundle.main.version
            let systemVersion = UIDevice.current.systemVersion
            let keepMeLoggedIn = true
            let deviceID = ProvisionalCookieConfiguration.deviceID
        }
        
        /// A type to hold credentials for credential based authentication
        struct Credentials: Codable {
            let username: String
            let password: String
        }
        
    }
}
