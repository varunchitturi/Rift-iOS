//
//  LogInUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

import Foundation
import UIKit

extension LogIn: NetworkSentinel, StorageManager {
    
    static let samlDOMID = "samlLoginLink"
    
    static let storageIdentifier = String(describing: Self.self)
    
    static let safeWebViewHosts = [
        URL(string: "https://accounts.google.com/")!
    ]
    
    // TODO: change the following values to enum
    static let authURLEndpoint = "verify.jsp"
    static let provisionEndpoint = "mobile/hybridAppUtil.jsp"
    static let persistenceUpdateEndpoint = "resources/portal/hybrid-device/update"
    
    static let persistentCookieName = "persistent-cookie"
    static let persistencePreferenceKey = "persistence"
    
    static let sharedURLSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpCookieStorage = .shared
        return URLSession(configuration: configuration)
    }()
    
    enum RequiredCookieName: String, CaseIterable {
        case jsession = "JSESSIONID"
        case xsrf = "XSRF-TOKEN"
        case sisCookie = "sis-cookie"
        case appName
        case portalApp
    }
    
    struct ProvisionalCookieConfiguration: Encodable {
        
        init(appName: String) {
            self.appName = appName
        }
        
        static let bootstrappedCode = "1"
        static let registrationToken = UUID().uuidString
        static let deviceID = UUID().uuidString
        
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
    
    struct PersistenceUpdateConfiguration: Encodable {
        let registrationToken = ProvisionalCookieConfiguration.registrationToken
        let deviceType = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        let appVersion = Bundle.main.version
        let systemVersion = UIDevice.current.systemVersion
        let keepMeLoggedIn: Bool
        let deviceID = ProvisionalCookieConfiguration.deviceID
    }
}
