//
//  LogInViewModel.swift
//  LogInViewModel
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import SwiftSoup

class LogInViewModel: ObservableObject {
    @Published private var logIn: LogIn
    
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
    
    // MARK: - Intents
    
}
