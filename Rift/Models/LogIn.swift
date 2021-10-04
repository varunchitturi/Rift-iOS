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
    
    
    struct Credentials {
        let username: String
        let password: String
    }
}
