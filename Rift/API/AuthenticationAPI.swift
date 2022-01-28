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
            
            API.authenticationRequestManager.resetSession()
         
            getPortalConfig(for: locale) { error in
                if let error = error {
                    completion(error)
                }
                else {
                    API.authenticationRequestManager.get(url: locale.logInURL) { result in
                        switch result {
                        case .success(_):
                            API.defaultRequestManager.post(endpoint: Endpoint.provisionalCookies, data: ProvisionalCookieConfiguration(appName: locale.districtAppName), encodeType: .form, locale: locale) { result in
                                switch result {
                                case .success(_):
                                    getProvisions(for: locale) { error in
                                        if let error = error {
                                            completion(error)
                                        }
                                        else {
                                            completion(nil)
                                        }
                                    }
                                case .failure(let error):
                                    completion(error)
                                }
                            }
                        case .failure(let error):
                            completion(error)
                        }
                    }
                }
            }
        }
        
        private static func getPortalConfig(for locale: Locale, completion: @escaping (Error?) -> ()) {
            API.authenticationRequestManager.get(endpoint: Endpoint.portalConfig, locale: locale) { result in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        private static func getProvisions(for locale: Locale, completion: @escaping (Error?) -> ()) {
            API.authenticationRequestManager.get(endpoint: Endpoint.provisionalCookies, locale: locale) { result in
                switch result {
                case .success(_):
                    if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == API.Authentication.Cookie.sis.name}) == true {
                        completion(nil)
                    }
                    else {
                        completion(APIError.invalidCookies)
                    }
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
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
        
        static func usePersistence(locale: Locale? = nil, _ isPersistent: Bool, completion: @escaping (Error?) -> ()) {
            
            API.authenticationRequestManager.post(endpoint: Endpoint.persistenceUpdate, data: PersistenceUpdateConfiguration(), encodeType: .json, locale: locale) { result in
                switch result {
                case .success(_):
                    if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == Cookie.persistent.name}) == true {
                        completion(nil)
                    }
                    else {
                        print("invalid")
                        completion(API.APIError.invalidCookies)
                    }
                case .failure(let error):
                    print(error)
                    completion(error)
                }
            }
        }
        
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
        
        static func attemptCredentialAuthentication(locale: Locale, credentials: Credentials, completion: @escaping (Result<ApplicationModel.AuthenticationState, Error>) -> ()) {
            
            guard let appCookie = HTTPCookie(properties: [.name : Authentication.Cookie.appName.name,
                                                    .value : locale.districtAppName,
                                                    .domain: locale.districtBaseURL.host?.description ?? "",
                                                    .path: "/"
                                                   ])
            else {
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
        
        static func logOut(locale: Locale? = nil, completion: @escaping (Error?) -> ()) {
            guard let locale = locale ?? PersistentLocale.getLocale() else { return }
            let query = URLQueryItem(name: "app", value: ApplicationModel.appType.rawValue)
            guard let url = locale.districtBaseURL
                                    .appendingPathComponent(Endpoint.logOut)
                                    .appendingQueryItems([query])
            else {
                completion(APIError.invalidRequest)
                return
            }
            API.authenticationRequestManager.get(url: url) { result in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
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
