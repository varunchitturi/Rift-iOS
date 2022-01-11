//
//  ApplicationViewModel.swift
//  ApplicationViewModel
//
//  Created by Varun Chitturi on 9/24/21.
//

import Firebase
import SwiftUI
import URLEncodedForm

class ApplicationViewModel: ObservableObject {
    @Published private var applicationModel = ApplicationModel()
    @Published var networkState: AsyncState = .idle
    
    var locale: Locale? {
        applicationModel.locale
    }
    
    var authenticationState: ApplicationModel.AuthenticationState {
        get {
            applicationModel.authenticationState
        }
        set {
            applicationModel.authenticationState = newValue
        }
    }
    
    init() {
        authenticateUsingCookies()
    }
    
    func authenticateUsingCookies() {
        let usePersistence = UserDefaults.standard.bool(forKey: UserPreferenceModel.persistencePreferenceKey)
        if usePersistence {
            networkState = .loading
            API.Authentication.attemptAuthentication { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let authenticationState):
                        self?.applicationModel.authenticationState = authenticationState
                        self?.networkState = .success
                        Analytics.logEvent(Analytics.LogInEvent(method: .automatic))
                    case .failure(let error):
                        print(error)
                        self?.networkState = .failure(error)
                    }
                }
            }
        }
    }
    
    func resetApplicationState() {
        applicationModel.resetUserState()
        authenticationState = .unauthenticated
    }
}
