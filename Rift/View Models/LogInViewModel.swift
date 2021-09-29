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
    
    var webViewURL: URL? = nil
    
    var isAuthenticated: Bool {
        guard let webViewURL = webViewURL else {
            return false
        }
        let portalURL = locale.districtBaseURL.appendingPathComponent(LogIn.portalViewPath)

        let webViewURLSearchingRange = min(3,webViewURL.pathComponents.count)
        let baseURLSearchingeRange = min(3,portalURL.pathComponents.count)
        
        return webViewURL.host == portalURL.host && webViewURL.pathComponents[..<webViewURLSearchingRange] == portalURL.pathComponents[..<baseURLSearchingeRange]
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
    
    var safeWebViewHostURLs: [URL] {
        LogIn.safeSSOHostURLs + [locale.districtBaseURL]
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
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies { cookies in
            let cookies = cookies.filter {LogIn.RequiredCookieName.allCases.map {$0.rawValue}.contains($0.name)}
            cookies.forEach {
                // explain why we do this
                if $0.name != LogIn.RequiredCookieName.jsession.rawValue {
                    HTTPCookieStorage.shared.setCookie($0)
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            switch keyPath {
            case "URL":
                guard let value = change?[NSKeyValueChangeKey.newKey], let url = value as? URL, let _ = url.host else {
                    self.singleSignOnIsPresented = false
                    return
                }
                webViewURL = url
                if isAuthenticated || (!safeWebViewHostURLs.contains(where: {$0.host == url.host})) {
                    singleSignOnIsPresented = false
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
        state.wrappedValue = isAuthenticated
    }
    
    func setPersistence(_ persistence: Bool) {
        logIn.usePersistence(persistence)
    }

    func promptSingleSignOn() {
        singleSignOnIsPresented = true
    }
    
   
    
}
