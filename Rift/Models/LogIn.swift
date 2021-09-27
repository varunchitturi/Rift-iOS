//
//  LogIn.swift
//  LogIn
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import SwiftSoup
import URLEncodedForm
import KeychainAccess

struct LogIn {
    
    
    let locale: Locale
    
    var ssoURL: URL?
    var loginURL: URL {
        switch Application.appType {
        case .student:
            return locale.studentLoginURL
        case .parent:
            return locale.parentLoginURL
        case .staff:
            return locale.staffLoginURL
        }
        
    }
    
    var authURL: URL {
        locale.districtBaseURL.appendingPathComponent(LogIn.authURLEndpoint)
    }
    
    var provisionURL: URL {
        locale.districtBaseURL.appendingPathComponent(LogIn.provisionEndpoint)
    }
    
    var persistenceUpdateURL: URL {
        locale.districtBaseURL.appendingPathComponent(LogIn.persistenceUpdateEndpoint)
    }
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    var authenticationCookiesExist: Bool {
        if let cookies = HTTPCookieStorage.shared.cookies {
            let cookieNames = cookies.map {$0.name}
            if Set(LogIn.RequiredCookieName.allCases.map {$0.rawValue}).isSubset(of: Set(cookieNames)) {
                return true
                
            }
        }
        return false
    }
    
    func getProvisionalCookies(completion: @escaping (Error?) -> ()) {
        let provisionalCookieConfiguration = ProvisionalCookieConfiguration(appName: locale.districtAppName)
        var urlRequest =  URLRequest(url: provisionURL)
        urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
        urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
        let formEncoder = URLEncodedFormEncoder()
        do {
            urlRequest.httpBody = try formEncoder.encode(provisionalCookieConfiguration)
            LogIn.sharedURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(error)
                }
                else {
                    completion(nil)
                }
            }
            .resume()
        }
        catch {
            completion(error)
        }
    }
    
    
    func getLogInSSO(completion: @escaping (Result<URL?, Error>)  -> ())  {
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
    
    func usePersistence(_ isPersistent: Bool) {
        
        var urlRequest =  URLRequest(url: persistenceUpdateURL)
        urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
        urlRequest.setValue(URLRequest.ContentType.json.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
        let jsonEncoder = JSONEncoder()
        let persistenceUpdateConfiguration = PersistenceUpdateConfiguration(keepMeLoggedIn: isPersistent)
        
        let persistenceFailed: () -> () = {
            UserDefaults.standard.set(false, forKey: LogIn.persistencePreferenceKey)
        }
        let persistenceSuccess: () -> () = {
            // TODO: remove this
            UserDefaults.standard.set(isPersistent, forKey: LogIn.persistencePreferenceKey)
        }
        
        do {
            urlRequest.httpBody = try jsonEncoder.encode(persistenceUpdateConfiguration)
            let urlConfiguration = URLSessionConfiguration.ephemeral
            urlConfiguration.httpShouldSetCookies = true
            urlConfiguration.httpCookieStorage = .shared
            URLSession(configuration: urlConfiguration).dataTask(with: urlRequest) { data, response, error in
                if let response = response as? HTTPURLResponse, let responseURL = response.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.allHeaderFields as! [String : String], for: responseURL)
                    if let persistentCookieIndex = cookies.firstIndex(where: {$0.name == LogIn.persistentCookieName}),
                       let cookieData = try? NSKeyedArchiver.archivedData(withRootObject: cookies[persistentCookieIndex], requiringSecureCoding: false) {
                        let keychain = Keychain(service: LogIn.storageIdentifier).synchronizable(true)
                        keychain[data: LogIn.persistentCookieName] = cookieData
                        persistenceSuccess()
                    }
                    else {
                        persistenceFailed()
                    }
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
    
    struct Credentials {
        let username: String
        let password: String
    }
}
