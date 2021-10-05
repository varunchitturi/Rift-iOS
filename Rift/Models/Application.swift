//
//  Application.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

import Foundation
import URLEncodedForm

// TODO: declare the structure of source files. statics, properties, inits, static methods, methods
// TODO: handle http status codes

struct Application {
    
    static var appType: AppType = .student
    
    var authenticationState: AuthenticationState = .loading
    
    
    func resetUserState() {
        HTTPCookieStorage.shared.clearCookies()
        _ = try? PersistentLocale.clearLocale()
        UserDefaults.standard.set(false, forKey: UserPreference.persistencePreferenceKey)
    }
    
    enum AppType: String {
        case student, parent, staff
        
        var description: String {
            self.rawValue
        }
    }
    
    enum AuthenticationState {
        case loading
        case authenticated
        case unauthenticated
    }
}
