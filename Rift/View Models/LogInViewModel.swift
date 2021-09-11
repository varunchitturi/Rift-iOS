//
//  LogInViewModel.swift
//  LogInViewModel
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import WebKit
import SwiftSoup

class LogInViewModel: NSObject, ObservableObject, WKHTTPCookieStoreObserver {
    
    @Published private var logIn: LogIn
    @Published var singleSignOnIsPresented = false
    
    var authCookies: HTTPCookieStorage {
        get {
            logIn.authCookies
        }
        set {
            logIn.authCookies = newValue
        }
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
                    self?.logIn.authCookies.setCookie(cookie)
                }
                self?.logIn.ssoUrl = ssoUrl
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies { cookies in
            print(cookies)
        }
    }
    
    // MARK: - Intents
    
}
