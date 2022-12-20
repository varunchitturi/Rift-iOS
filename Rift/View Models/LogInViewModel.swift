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

/// MVVM view model for the `LogInView`
class LogInViewModel: NSObject, ObservableObject {
    
    /// MVVM model
    @Published private var logInModel: LogInModel
    
    /// Gives whether a web view for single sign on is presented
    @Published var singleSignOnIsPresented = false
    
    /// Gives the type of alert that is being presented
    /// - `nil` if there is no alert being presented
    @Published var presentedAlert: AlertType? = nil
    
    /// `AsyncState` to manage network calls in views
    @Published var defaultNetworkState: AsyncState = .idle
    
    /// `AsyncState` to manage network calls in the web view
    @Published var webViewNetworkState: AsyncState = .idle
    
    var alertIsPresented: Bool {
        get {
            presentedAlert != nil
        }

        set {
            presentedAlert = newValue ? .none : nil
        }
    }
    
    let webViewDataStore = WKWebsiteDataStore.default()

    /// SSO URLs that the presented web view is allowed to navigate to
    private static let ssoURLs = [
        URL(string: "https://accounts.google.com/")!,
        URL(string: "https://accounts.youtube.com/")!,
        URL(string: "https://login.microsoftonline.com/")!,
        URL(string: "https://login.live.com/")!,
        URL(string: "https://github.com/")!,
    ]
    
    /// The current URL of the web view
    var webViewURL: URL? = nil
    
    /// Gives whether the user is authenticated
    /// - The user could have been authenticated using credentials or SSO
    var isAuthenticated: Bool {
        ssoAuthenticationState == .authenticated || credentialAuthenticationState == .authenticated
    }
    
    /// Gives whether the user has been authenticated using SSO
    var ssoAuthenticationState: ApplicationModel.AuthenticationState {
        guard let webViewURL = webViewURL else {
            return .unauthenticated
        }
        let portalURL = locale.districtBaseURL.appendingPathComponent(API.Authentication.successPath)

        let webViewURLSearchingRange = min(3, webViewURL.pathComponents.count)
        let baseURLSearchingRange = min(3, portalURL.pathComponents.count)
        
        if webViewURL.host == portalURL.host &&
            webViewURL.pathComponents[..<webViewURLSearchingRange] == portalURL.pathComponents[..<baseURLSearchingRange] &&
            webViewURL.lastPathComponent == API.Authentication.successPath {
            return .authenticated
        }
        
        return .unauthenticated
    }
    
    /// Gives whether the user been authenticated using credentials
    private var credentialAuthenticationState = ApplicationModel.AuthenticationState.unauthenticated
    
    /// The locale the user chose for the log in process
    private var locale: Locale {
        logInModel.locale
    }
    
    /// The sso URL for the locale, if available
    var ssoURL: URL? {
        logInModel.ssoURL
    }
    
    /// The URL the web view goes to if sso authentication has failed
    var ssoConfirmationURL: URL? {
        if ssoURL != nil {
            return locale.districtBaseURL.appendingPathComponent("SSO/\(locale.districtAppName)/SIS")
        }
        return nil
    }
    
    /// The url for the log in page for the locale
    var logInURL: URL {
        locale.logInURL
    }
    
    /// Gives whether the chosen locale supports sso authentication
    var hasSSOLogin: Bool {
        logInModel.ssoURL != nil
    }
    
    /// All URLs that the presented web view is allowed to navigate to
    var safeWebViewHostURLs: [URL] {
        LogInViewModel.ssoURLs + [locale.districtBaseURL]
    }
    
    init(locale: Locale) {
        logInModel = LogInModel(locale: locale)
        super.init()
        loadLogInOptions()
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
                if ssoAuthenticationState == .authenticated || (!safeWebViewHostURLs.contains(where: {$0.host == url.host})) {
                    singleSignOnIsPresented = false
                }
            default:
                return
            }
        }
    }
    
    
    /// Load the available log in methods for the given locale
    func loadLogInOptions() {
        defaultNetworkState = .loading
        API.Authentication.getLogInSSO(for: locale) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ssoURL):
                    self?.logInModel.ssoURL = ssoURL
                    self?.defaultNetworkState = .idle
                case .failure(let error):
                    self?.defaultNetworkState = .failure(error)
                }
            }
        }
    }
    
    /// Gets the cookies needed to start sso authentication
    func provisionSSOAuthentication() {
        webViewNetworkState = .loading
        API.Authentication.getProvisionalCookies(for: locale) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.webViewNetworkState = .failure(error)
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.webViewNetworkState = .success
                }
            }
        }
    }
    
    // MARK: - Intents
    
    /// Authenticates the user using credentials
    /// - Parameter credentials: The log in credentials of the user
    func authenticate(using credentials: API.Authentication.Credentials) {
        defaultNetworkState = .loading
        API.Authentication.getProvisionalCookies(for: locale) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.defaultNetworkState = .failure(error)
                }
            }
            else if let self = self {
                API.Authentication.attemptCredentialAuthentication(locale: self.locale, credentials: credentials) { result in
                    switch result {
                    case .success(let authenticationState):
                        DispatchQueue.main.async {
                            self.credentialAuthenticationState = authenticationState
                            self.defaultNetworkState = .success
                            switch authenticationState {
                            case .authenticated:
                                self.presentedAlert = .persistencePrompt
                            case .unauthenticated:
                                self.presentedAlert = .credentialError
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.defaultNetworkState = .failure(error)
                        }
                    }
                }
            }
        }
    }
    
    /// Updates the application authentication state based on whether credential or sso authentication has succeeded
    /// - Parameter state: A binding to the application's authentication to update
    func authenticate(for state: Binding<ApplicationModel.AuthenticationState>) {
        switch (ssoAuthenticationState, credentialAuthenticationState) {
        case (let ssoAuthenticationState, _ ) where ssoAuthenticationState == .authenticated:
            state.wrappedValue = ssoAuthenticationState
            Analytics.logEvent(Analytics.LogInEvent(method: .manual, process: .sso))
        case ( _ , let credentialAuthenticationState) where credentialAuthenticationState == .authenticated:
            state.wrappedValue = credentialAuthenticationState
            Analytics.logEvent(Analytics.LogInEvent(method: .manual, process: .credential))
        default:
            state.wrappedValue = .unauthenticated
        }
    }
    
    /// Gets the necessary cookies need to persist log in and sets the "remember me" preference for the user
    /// - Parameters:
    ///   - persistencePreference:Boolean indicating whether the user wants to persist their log in
    ///   - completion: Completion function
    func setPersistence(_ persistencePreference: Bool, completion: @escaping () -> () = {}) {
        if (try? PersistentLocale.saveLocale(locale: self.locale)) != nil {
            webViewDataStore.httpCookieStore.getAllCookies { cookies in
                let cookies = cookies.filter { API.Authentication.Cookie.allCases.map { $0.name }.contains($0.name)}
                cookies.forEach {
                    HTTPCookieStorage.shared.setCookie($0)
                }
                API.Authentication.usePersistence(locale: self.locale) { error in
                    if error != nil {
                        UserDefaults.standard.set(false, forKey: UserPreferenceModel.persistencePreferenceKey)
                    }
                    else {
                        UserDefaults.standard.set(persistencePreference, forKey: UserPreferenceModel.persistencePreferenceKey)
                    }
                    completion()
                }
            }
        }
        else {
            self.defaultNetworkState = .failure(API.APIError.invalidLocale)
        }
    }
    
    /// A type of alert to present during log in errors
    enum AlertType: String, Identifiable {
        case persistencePrompt
        case credentialError
        case serverError
        
        var id: Int {
            return self.hashValue
        }
        
        var title: String {
            let errorTitle = "Unable to Log In"
            switch self {
            case .persistencePrompt:
                return "Stay Logged In"
            case .credentialError:
                return errorTitle
            case .serverError:
                return errorTitle
            }
        }
        
        var message: String {
            switch self {
            case .persistencePrompt:
                return "Would you like \(Bundle.main.displayName ?? "us") to keep you logged in?"
            case .credentialError:
                return "Please make sure that your credentials are correct and you are using the correct log in method."
            case .serverError:
                return "An error occurred while logging you in. Please try again in a few moments."
            }
        }
        
        
    }
   
    
}
