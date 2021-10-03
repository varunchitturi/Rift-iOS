//
//  LogIn.swift
//  LogIn
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import SwiftSoup
import URLEncodedForm
import CoreData

struct LogIn {
    // TODO: change cookies and cache deletion calls to the URLSession reset method
    // TODO: if the screen on the webview goes to an infinite campus website, that shows an error, handle it cleanly
    
    let locale: Locale
    
    var ssoURL: URL?
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
    
    var authURL: URL {
        locale.districtBaseURL.appendingPathComponent(LogIn.API.authURLEndpoint)
    }
    
    var provisionURL: URL {
        locale.districtBaseURL.appendingPathComponent(LogIn.API.provisionEndpoint)
    }
    
    var persistenceUpdateURL: URL {
        locale.districtBaseURL.appendingPathComponent(LogIn.API.persistenceUpdateEndpoint)
    }
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    func authenticationCookiesExist(for cookies: [HTTPCookie]?) -> Bool {
        if let cookies = cookies {
            let cookieNames = cookies.map {$0.name}
            if Set(LogIn.RequiredCookieName.allCases.map {$0.rawValue}).isSubset(of: Set(cookieNames)) {
                return true
                
            }
        }
        return false
    }
    
    func getProvisionalCookies(completion: @escaping (Error?) -> ()) {
        LogIn.sharedURLSession = URLSession.reset(from: LogIn.sharedURLSession)
        HTTPCookieStorage.shared.clearCookies()
        let provisionalCookieConfiguration = ProvisionalCookieConfiguration(appName: locale.districtAppName)
        var urlRequest =  URLRequest(url: provisionURL)
        urlRequest.httpMethod = URLRequest.HTTPMethod.post.rawValue
        urlRequest.setValue(URLRequest.ContentType.form.rawValue, forHTTPHeaderField: URLRequest.Header.contentType.rawValue)
        let formEncoder = URLEncodedFormEncoder()
        do {
            urlRequest.httpBody = try formEncoder.encode(provisionalCookieConfiguration)
            LogIn.sharedURLSession.dataTask(with: urlRequest) { data, response, error in
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
            LogIn.sharedURLSession.dataTask(with: urlRequest) { data, response, error in
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
    
    struct Credentials {
        let username: String
        let password: String
    }
}
