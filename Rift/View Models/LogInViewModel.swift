//
//  LogInViewModel.swift
//  LogInViewModel
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import WebKit
import SwiftUI

class LogInViewModel: NSObject, ObservableObject, WKHTTPCookieStoreObserver {
    
    @Published private var logIn: LogIn
    @Published var singleSignOnIsPresented = false
    var isAuthenticated = false
    
    var locale: Locale {
        logIn.locale
    }
    
    var ssoURL: URL? {
        logIn.ssoUrl
    }
    
    var hasSSOLogin: Bool {
        logIn.ssoUrl != nil
    }
    
    init(locale: Locale) {
        logIn = LogIn(locale: locale)
        super.init()
        logIn.getLogInInfo {[weak self] result in
            switch result {
            case .success((let cookies, let ssoUrl)):
                for cookie in cookies {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
                self?.logIn.ssoUrl = ssoUrl
            case .failure(let error):
                // TODO: do bettter error handling here
                print("Log in error")
                print(error.localizedDescription)
            }
        }
    }
    
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies {[weak self] cookies in
            let cookies = cookies.filter {LogIn.authCookieNames.contains($0.name)}
            if (cookies.map {$0.name}).sorted() == LogIn.authCookieNames.sorted() {
                cookies.forEach {HTTPCookieStorage.shared.setCookie($0)}
                self?.singleSignOnIsPresented = false
                self?.isAuthenticated = true
            }
        }
    }
    
    // MARK: - Intents
    
    func authenticate(with credentials: LogIn.Credentials) {
        // TODO: implement this for normal sign in
        
    }
    
    func authenticate(for state: Binding<Bool>) {
        state.wrappedValue = isAuthenticated
    }

    func promptSingleSignOn() {
        singleSignOnIsPresented = true
    }
    
   
    
}
