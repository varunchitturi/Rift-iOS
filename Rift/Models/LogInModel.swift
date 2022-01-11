//
//  LogInModel.swift
//  LogInModel
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import SwiftSoup
import URLEncodedForm
import CoreData

struct LogInModel {
    // TODO: change cookies and cache deletion calls to the URLSession reset method
    // TODO: if the screen on the webview goes to an infinite campus website, that shows an error, handle it cleanly
    
    let locale: Locale
    
    var ssoURL: URL?
    
    func authenticationCookiesExist(in cookies: [HTTPCookie]) -> Bool {
        let cookieNames = cookies.map {$0.name}
        if Set(API.Authentication.Cookie.allCases.filter {$0.isRequired}.map {$0.name}).isSubset(of: Set(cookieNames)) {
            return true
        }
        return false
    }
    
    
    struct Credentials {
        let username: String
        let password: String
    }
    
    enum AuthenticationType {
        case sso
        case credential
    }
    
}
