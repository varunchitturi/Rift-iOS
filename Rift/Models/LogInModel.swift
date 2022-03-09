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

/// MVVM model for the log in process
struct LogInModel {
    // TODO: change cookies and cache deletion calls to the URLSession reset method
    // TODO: if the screen on the webview goes to an infinite campus website, that shows an error, handle it cleanly
    
    
    /// The selected `Locale` to log into
    let locale: Locale
    
    /// The single sign on `URL` if sso is enabled for the locale
    var ssoURL: URL?
    
    /// Gives wether if the necessary cookies exist to authenticate the user
    /// - Parameter cookies: An array of cookies to check
    /// - Returns: A boolean giving wether the necessary cookies exist.
    func authenticationCookiesExist(in cookies: [HTTPCookie]) -> Bool {
        let cookieNames = cookies.map {$0.name}
        if Set(API.Authentication.Cookie.allCases.filter {$0.isRequired}.map {$0.name}).isSubset(of: Set(cookieNames)) {
            return true
        }
        return false
    }
    
    /// The type of process used to authenticate the user
    enum AuthenticationType {
        case sso
        case credential
    }
    
}
