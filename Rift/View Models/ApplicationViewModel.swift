//
//  ApplicationViewModel.swift
//  ApplicationViewModel
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI
import URLEncodedForm

class ApplicationViewModel: ObservableObject {
    @Published private var applicationModel = ApplicationModel()
    
    init() {
        authenticateUsingCookies()
    }
    
    func authenticateUsingCookies() {
        let usePersistence = UserDefaults.standard.bool(forKey: UserPreferenceModel.persistencePreferenceKey)
        if usePersistence {
            API.Authentication.attemptAuthentication { result in
                switch result {
                case .success(let authenticationState):
                    self.applicationModel.authenticationState = authenticationState
                case .failure(let error):
                    self.applicationModel.authenticationState = .failure(error)
                }
            }
        }
        else {
            applicationModel.authenticationState = .unauthenticated
        }
    }
    
    func resetApplicationState() {
        applicationModel.resetUserState()
        authenticationState = .unauthenticated
    }
    
    var authenticationState: ApplicationModel.AuthenticationState {
        get {
            applicationModel.authenticationState
        }
        set {
            applicationModel.authenticationState = newValue
        }
        
    }
}
