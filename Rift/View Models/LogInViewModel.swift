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
    @Published var requestState: RequestState = .idle
    @Published var persistenceAlertIsPresented = false
    
    var webViewURL: URL? = nil
    var authenticationCookiesExist = false
    
    var isAuthenticated: Bool {
        webViewURL?.host == locale.districtBaseURL.host && webViewURL?.pathComponents[..<2] == locale.districtBaseURL.appendingPathComponent(LogIn.homeViewPath).pathComponents[..<2] && authenticationCookiesExist
    }

    var locale: Locale {
        logIn.locale
    }
    
    var ssoURL: URL? {
        logIn.ssoURL
    }
    
    var hasSSOLogin: Bool {
        logIn.ssoURL != nil
    }
    
    init(locale: Locale) {
        logIn = LogIn(locale: locale)
        super.init()
        requestState = .loading
        logIn.getProvisionalCookies {[weak self] error in
            if let error = error {
                self?.requestState = .failure
                print(error)
            }
            else {
                self?.logIn.getLogInSSO { result in
                    switch result {
                    case .success(let ssoURL):
                        self?.logIn.ssoURL = ssoURL
                        self?.requestState = .idle
                    case .failure(let error):
                        // TODO: do bettter error handling here
                        self?.requestState = .failure
                        print("Log in error")
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    // TODO: create a cleaner or better way to get authentication state
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies {[weak self] cookies in
            let cookies = cookies.filter {LogIn.RequiredCookieName.allCases.map {$0.rawValue}.contains($0.name)}
            cookies.forEach {
                if $0.name != LogIn.RequiredCookieName.jsession.rawValue {
                    HTTPCookieStorage.shared.setCookie($0)
                }
            }
            self?.authenticationCookiesExist = self?.logIn.authenticationCookiesExist(for: cookies) ?? false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            switch keyPath {
            case "URL":
                if let value = change?[NSKeyValueChangeKey.newKey], let url = value as? URL, let _ = url.host {
                    webViewURL = url
                    if !LogIn.safeWebViewHosts.contains(where: {$0.host == url.host}) && logIn.ssoURL != url {
                        self.singleSignOnIsPresented = false
                    }
                }
                else {
                    self.singleSignOnIsPresented = false
                }
                if isAuthenticated {
                    persistenceAlertIsPresented = true
                    print("authenticated")
                }
            default:
                return
            }
        }
    }
    
    // MARK: - Intents
    
    func authenticate(with credentials: LogIn.Credentials) {
        // TODO: implement this for normal sign in
        
    }
    
    func authenticate(for state: Binding<Bool>) {
        let isAuthenticated = isAuthenticated
        state.wrappedValue = isAuthenticated
    }
    
    func setPersistence(_ persistence: Bool) {
        logIn.usePersistence(persistence)
    }

    func promptSingleSignOn() {
        singleSignOnIsPresented = true
    }
    
   
    
}
