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
    
    static let safeSSOHostURLs = [
        URL(string: "https://accounts.google.com/")!
    ]
    

    static let persistentCookieName = "persistent_cookie"
    
    static var sharedURLSession: URLSession = {
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
    
    struct PersistenceUpdateConfiguration: Encodable {
        let registrationToken = ProvisionalCookieConfiguration.registrationToken
        let deviceType = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        let appVersion = Bundle.main.version
        let systemVersion = UIDevice.current.systemVersion
        let keepMeLoggedIn = true
        let deviceID = ProvisionalCookieConfiguration.deviceID
    }
}
