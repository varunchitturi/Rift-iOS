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
            API.Authentication.attemptCookieAuthentication { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let authenticationState):
                        self?.applicationModel.authenticationState = authenticationState
                        self?.networkState = .success
                        if authenticationState == .authenticated {
                            Analytics.logEvent(Analytics.LogInEvent(method: .automatic))
                        }
                    case .failure(let error):
                        self?.networkState = .failure(error)
                    }
                }
            }
        }
    }
    
    private func resetApplicationState() {
        applicationModel.resetUserState()
        authenticationState = .unauthenticated
    }
    
    func logOut() {
        networkState = .loading
        API.Authentication.logOut { _ in
            Analytics.logEvent(Analytics.LogOutEvent())
            FirebaseApp.clearUser()
            DispatchQueue.main.async {
                self.resetApplicationState()
                self.networkState = .idle
            }
        }
    }
}
