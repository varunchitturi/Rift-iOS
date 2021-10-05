//
//  ApplicationViewModel.swift
//  ApplicationViewModel
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI
import URLEncodedForm

class ApplicationViewModel: ObservableObject {
    @Published private var application = Application()
    
    init() {
        let usePersistence = UserDefaults.standard.bool(forKey: UserPreference.persistencePreferenceKey)
        if usePersistence {
            API.Authentication.attemptAuthentication { authenticationState in
                DispatchQueue.main.async {
                    self.application.authenticationState = authenticationState
                }
            }
        }
        else {
            application.authenticationState = .unauthenticated
        }
    }
    
    func resetApplicationState() {
        application.resetUserState()
        authenticationState = .unauthenticated
    }
    
    var authenticationState: Application.AuthenticationState {
        get {
            application.authenticationState
        }
        set {
            application.authenticationState = newValue
        }
        
    }
}
