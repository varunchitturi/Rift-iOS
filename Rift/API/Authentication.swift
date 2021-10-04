//
//  Authentication.swift
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
        
        private static let provisionCookiesEndpoint = "mobile/hybridAppUtil.jsp"
        private static let persistenceUpdateEndpoint = "resources/portal/hybrid-device/update"
        private static let logOutEndpoint = "logoff.jsp"
        private static let authorizationEndpoint = "verify.jsp"
        private static let authenticationSuccessEndpoint = "nav-wrapper"
        
        func getProvisionalCookies(locale: Locale, completion: @escaping (Error?) -> ()) {
            Authentication.urlSession = URLSession.reset(from: Authentication.urlSession)
            HTTPCookieStorage.shared.clearCookies()
            let provisionalCookieConfiguration = ProvisionalCookieConfiguration(appName: locale.districtAppName)
            var urlRequest =  URLRequest(url: locale.districtBaseURL.appendingPathComponent(Authentication.provisionCookiesEndpoint))
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
        
        func getLogInSSO(locale: Locale, completion: @escaping (Result<URL?, Error>)  -> ())  {
            
            var loginURL: URL {
                switch Application.appType {
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
                    let samlURLString: String = (try? htmlDOM.getElementById(LogIn.samlDOMID)?.attr("href")) ?? ""
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
        
        func usePersistence(locale: Locale, _ isPersistent: Bool) {
            
            let persistenceUpdateURL = locale.districtBaseURL.appendingPathComponent(Authentication.persistenceUpdateEndpoint)
            
            var urlRequest =  URLRequest(url: persistenceUpdateURL)
            urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
            urlRequest.setValue(URLRequest.ContentType.json.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
            let jsonEncoder = JSONEncoder()
            let persistenceUpdateConfiguration = PersistenceUpdateConfiguration()
            
            let persistenceFailed: () -> () = {
                UserDefaults.standard.set(false, forKey: UserPreference.persistencePreferenceKey)
            }
            let persistenceSuccess: () -> () = {
                // TODO: remove this
                UserDefaults.standard.set(isPersistent, forKey: UserPreference.persistencePreferenceKey)
                
            }
            
            do {
                urlRequest.httpBody = try jsonEncoder.encode(persistenceUpdateConfiguration)
                Authentication.urlSession.dataTask(with: urlRequest) { data, response, error in
                    if HTTPCookieStorage.shared.cookies?.contains(where: {$0.name == LogIn.persistentCookieName}) == true {
                        persistenceSuccess()
                    }
                    else {
                        persistenceFailed()
                    }
                }
                .resume()
            }
            catch {
                persistenceFailed()
            }
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
            let appType = Application.appType.description
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
