//
//  LogInUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

import Foundation
import UIKit

extension LogIn: NetworkSentinel {
    
    static let samlDOMID = "samlLoginLink"
    
    
    static let safeSSOHostURLs = [
        URL(string: "https://accounts.google.com/")!
    ]
    

    static let persistentCookieName = "persistent_cookie"
    
    
    enum RequiredCookieName: String, CaseIterable {
        case jsession = "JSESSIONID"
        case xsrf = "XSRF-TOKEN"
        case sisCookie = "sis-cookie"
        case appName
        case portalApp
    }
    

}
