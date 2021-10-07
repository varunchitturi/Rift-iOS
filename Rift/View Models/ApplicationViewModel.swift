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
        let usePersistence = UserDefaults.standard.bool(forKey: UserPreferenceModel.persistencePreferenceKey)
        if usePersistence {
            print("yes")
            API.Authentication.attemptAuthentication { authenticationState in
                DispatchQueue.main.async {
                    self.applicationModel.authenticationState = authenticationState
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
