//
//  ApplicationModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

// TODO: fix header comments for files
import Foundation
import URLEncodedForm

// TODO: declare the structure of source files. statics, properties, inits, static methods, methods
// TODO: handle http status codes

struct ApplicationModel {
    
    static var appType: AppType = .student
    
    var authenticationState: AuthenticationState = .loading
    
    
    func resetUserState() {
        HTTPCookieStorage.shared.clearCookies()
        URLCache.shared.removeAllCachedResponses()
        _ = try? PersistentLocale.clearLocale()
        UserDefaults.standard.set(false, forKey: UserPreferenceModel.persistencePreferenceKey)
    }
    
    enum AppType: String {
        case student, parent, staff
        
        var description: String {
            self.rawValue
        }
    }
    
    enum AuthenticationState: Equatable {
        
        static func == (lhs: ApplicationModel.AuthenticationState, rhs: ApplicationModel.AuthenticationState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.authenticated, .authenticated):
                return true
            case (.unauthenticated, .unauthenticated):
                return true
            case (.failure(_), .failure(_)):
                return true
            default:
                return false
            }
        }
        
        case loading
        case authenticated
        case unauthenticated
        case failure(Error)
    }
}
