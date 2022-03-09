//
//  ApplicationViewModel.swift
//  ApplicationViewModel
//
//  Created by Varun Chitturi on 9/24/21.
//

import Firebase
import SwiftUI
import URLEncodedForm

/// MVVM view model to handle the application state
class ApplicationViewModel: ObservableObject {
    
    /// MVVM model
    @Published private var applicationModel = ApplicationModel()
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .idle
    
    /// The current chosen `Locale` of the user if available
    var locale: Locale? {
        applicationModel.locale
    }
    
    /// The current authentication state of the application
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
    
    /// Tries to authenticate the user using stored cookies
    /// - Uses the `persistent-cookie` to get  a `JSESSIONID` authentication cookie for the user
    /// - Note: This only works if the user has selected "remember me" during a previous log in attempt
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
    
    /// Makes the user authenticated and removes any user authentication information
    private func resetApplicationState() {
        applicationModel.resetUserState()
        authenticationState = .unauthenticated
    }
    
    /// Logs out the user from the app
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
