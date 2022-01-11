//
//  LogInViewModel.swift
//  LogInViewModel
//
//  Created by Varun Chitturi on 9/9/21.
//

import CoreData
import Firebase
import Foundation
import SwiftUI
import WebKit

class LogInViewModel: NSObject, ObservableObject, WKHTTPCookieStoreObserver {
    
    @Published private var logInModel: LogInModel
    @Published var singleSignOnIsPresented = false
    @Published var networkState: AsyncState = .idle
    
    private static let SSOURLS = [
        URL(string: "https://accounts.google.com/")!
    ]
    
    var webViewURL: URL? = nil
    
    var authenticationState: ApplicationModel.AuthenticationState {
        guard let webViewURL = webViewURL else {
            return .unauthenticated
        }
        let portalURL = locale.districtBaseURL.appendingPathComponent(API.Authentication.successPath)

        let webViewURLSearchingRange = min(3,webViewURL.pathComponents.count)
        let baseURLSearchingRange = min(3,portalURL.pathComponents.count)
        
        if webViewURL.host == portalURL.host && webViewURL.pathComponents[..<webViewURLSearchingRange] == portalURL.pathComponents[..<baseURLSearchingRange] {
            if let _ = try? PersistentLocale.saveLocale(locale: locale) {
                return .authenticated
            }
        }
        
        return .unauthenticated
    }

    private var locale: Locale {
        logInModel.locale
    }
    
    var ssoURL: URL? {
        logInModel.ssoURL
    }
    
    var logInURL: URL {
        locale.logInURL
    }
    
    var hasSSOLogin: Bool {
        logInModel.ssoURL != nil
    }
    
    var safeWebViewHostURLs: [URL] {
        LogInViewModel.SSOURLS + [locale.districtBaseURL]
    }
    
    init(locale: Locale) {
        logInModel = LogInModel(locale: locale)
        super.init()
    }
    
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies { cookies in
            let cookies = cookies.filter {API.Authentication.Cookie.allCases.map { $0.name }.contains($0.name)}
            cookies.forEach {
                // explain why we do this. We don't want to replace the JSESSIONID obtained from provisional cookies
                if $0.name != API.Authentication.Cookie.jsession.name {
                    HTTPCookieStorage.shared.setCookie($0)
                }
                // provide better documentation on this. This is done to make sure that authentication passes. If we get conflicting cookie names that means authentication might have failed.
                else if let jsessionCookie = HTTPCookieStorage.shared.cookies?.first(where: {$0.name == API.Authentication.Cookie.jsession.name}), jsessionCookie.value != $0.value {
                    Crashlytics.crashlytics().record(error: API.APIError.invalidUser)
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            switch keyPath {
            case "URL":
                guard let value = change?[NSKeyValueChangeKey.newKey], let url = value as? URL, url.host != nil else {
                    self.singleSignOnIsPresented = false
                    return
                }
                webViewURL = url
                if authenticationState == .authenticated || (!safeWebViewHostURLs.contains(where: {$0.host == url.host})) {
                    singleSignOnIsPresented = false
                }
            default:
                return
            }
        }
    }
    
    
    func loadLogInOptions() {
        networkState = .loading
        API.Authentication.getLogInSSO(for: self.locale) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ssoURL):
                    self?.logInModel.ssoURL = ssoURL
                    self?.networkState = .idle
                case .failure(let error):
                    self?.networkState = .failure(error)
                }
            }
        }
    }
    
    func provisionAuthentication() {
        networkState = .loading
        API.Authentication.getProvisionalCookies(for: locale) {[weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.networkState = .failure(error)
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.networkState = .success
                }
            }
        }
    }
    
    // MARK: - Intents
    
    func authenticate(with credentials: LogInModel.Credentials) {
        // TODO: implement this for normal sign in
        Analytics.logEvent(Analytics.LogInEvent(method: .manual, process: .credential))
        
    }
    
    func authenticate(for state: Binding<ApplicationModel.AuthenticationState>) {
        state.wrappedValue = authenticationState
        Analytics.logEvent(Analytics.LogInEvent(method: .manual, process: .sso))
    }
    
    func setPersistence(_ persistence: Bool, completion: @escaping () -> () = {}) {
        API.Authentication.usePersistence(locale: locale, persistence) { error in
            if let _ = error {
                UserDefaults.standard.set(false, forKey: UserPreferenceModel.persistencePreferenceKey)
            }
            else {
                UserDefaults.standard.set(persistence, forKey: UserPreferenceModel.persistencePreferenceKey)
            }
            completion()
        }
    }

    
   
    
}
