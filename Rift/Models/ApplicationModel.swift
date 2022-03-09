//
//  ApplicationModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

import Foundation
import URLEncodedForm

// TODO: declare the structure and order of components of source files. statics, properties, inits, static methods, methods
// TODO: handle http status codes

/// MVVM Model to manage the application state
struct ApplicationModel {
    
    /// The configuration of Infinite Campus App to use
    static var appType: AppType = .student
    
    /// Gives if the user is currently authenticated or not
    var authenticationState: AuthenticationState = .unauthenticated
    
    /// The locale of the user if available
    var locale: Locale? {
        PersistentLocale.getLocale()
    }
    
    
    /// Clears are user authentication information from application
    /// - Clears all cookies
    /// - Clears cached responses
    /// - Clears user locale
    /// - Resets the `remember me` preference for the user
    mutating func resetUserState() {
        HTTPCookieStorage.shared.clearCookies()
        URLCache.shared.removeAllCachedResponses()
        _ = try? PersistentLocale.clearLocale()
        UserDefaults.standard.set(false, forKey: UserPreferenceModel.persistencePreferenceKey)
    }
    
    /// The configuration of Infinite Campus App
    /// - You can use `student`, `parent`, or `staff`
    enum AppType: String {
        case student, parent, staff
        
        /// String value of the Infinite Campus App configuration
        var description: String {
            self.rawValue
        }
    }
    
    /// The authentication state of the app
    enum AuthenticationState: Equatable {
        case authenticated
        case unauthenticated
    }
}
