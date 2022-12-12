//
//  LogInView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//


import CoreData
import Firebase
import SwiftUI

struct LogInView: View {
    
    @EnvironmentObject private var applicationViewModel: ApplicationViewModel
    @StateObject private var logInViewModel: LogInViewModel
    @State private var usernameIsEditing = false
    @State private var passwordIsEditing = false
    @State private var username: String = ""
    @State private var password: String = ""
    
    
    init(locale: Locale) {
        self._logInViewModel = StateObject(wrappedValue: LogInViewModel(locale: locale))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Spacer(minLength: DrawingConstants.formTopSpacing)
                if logInViewModel.hasSSOLogin {
                    CapsuleButton("Single Sign-On", style: .secondary) {
                        DispatchQueue.main.async {
                            usernameIsEditing = false
                            passwordIsEditing = false
                        }
                        logInViewModel.provisionSSOAuthentication()
                        logInViewModel.singleSignOnIsPresented = true
                    }
                    
                    TextDivider("or")
                        .padding(.vertical, DrawingConstants.dividerPadding)
                    Spacer()
                } 
                
                Spacer()
                CapsuleTextField("Username",
                                 text: $username,
                                 isEditing: $usernameIsEditing,
                                 icon: "person.fill",
                                 accentColor: Rift.DrawingConstants.accentColor,
                                 configuration: LegacyTextField.customInputConfiguration
                )
                    
                CapsuleTextField("Password",
                                 text: $password,
                                 isEditing: $passwordIsEditing,
                                 icon: "key.fill",
                                 accentColor:
                                    Rift.DrawingConstants.accentColor,
                                 isSecureStyle: true,
                                 configuration: LegacyTextField.customInputConfiguration
                )
            }
            .foregroundColor(Rift.DrawingConstants.foregroundColor)
            Spacer()
            CapsuleButton("Log In", style: .primary) {
                let credentials = API.Authentication.Credentials(username: username, password: password)
                logInViewModel.authenticate(using: credentials)
            }
        }
        .padding()
        .disabled(logInViewModel.presentedAlert != nil || logInViewModel.isAuthenticated)
        .apiHandler(asyncState: logInViewModel.defaultNetworkState) { _ in
            logInViewModel.loadLogInOptions()
        }
        .navigationTitle("Log In")
        .sheet(isPresented: $logInViewModel.singleSignOnIsPresented) {
            DispatchQueue.main.async {
                if logInViewModel.ssoAuthenticationState == .authenticated {
                    logInViewModel.presentedAlert = .persistencePrompt
                }
                else if logInViewModel.webViewURL == logInViewModel.ssoConfirmationURL {
                    logInViewModel.presentedAlert = .serverError
                }
            }
          
        } content: {
            WebView(request: URLRequest(url: logInViewModel.ssoURL!),
                    cookieObserver: logInViewModel,
                    urlObserver: logInViewModel,
                    initialCookies: HTTPCookieStorage.shared.cookies
            )
            .apiHandler(asyncState: logInViewModel.webViewNetworkState, loadingStyle: .progressCircle) { _ in
                logInViewModel.provisionSSOAuthentication()
            }
        }
        .alert(logInViewModel.presentedAlert?.title ?? "", isPresented: $logInViewModel.alertIsPresented, presenting: logInViewModel.presentedAlert) { alert in
            switch alert {
            case .persistencePrompt:
                Button("Not Now") {
                    logInViewModel.setPersistence(false) {
                        DispatchQueue.main.async {
                            logInViewModel.authenticate(for: $applicationViewModel.authenticationState)
                        }
                    }
                }
                Button("Yes") {
                    logInViewModel.setPersistence(true) {
                        DispatchQueue.main.async {
                            logInViewModel.authenticate(for: $applicationViewModel.authenticationState)
                        }
                    }
                }
            default:
                Button("Dismiss", role: .cancel, action: {})
            }
        } message: { alert in
            Text(alert.message)
        }
    }
    
    private enum DrawingConstants {
        static let dividerPadding: CGFloat = 20
        static let formTopSpacing: CGFloat = 15
    }
    
}

#if DEBUG
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(locale: Locale(id: 1, districtName: "District Name", districtAppName: "FUSD", districtBaseURL: URL(string: "https://")!, districtCode: "fusd", state: .CA, staffLogInURL: URL(string: "https://")!, studentLogInURL: URL(string: "https://")!, parentLogInURL: URL(string: "https://")!))
            .preferredColorScheme(.dark)
    }
}
#endif
