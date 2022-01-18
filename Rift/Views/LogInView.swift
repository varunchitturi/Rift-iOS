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
    @ObservedObject var logInViewModel: LogInViewModel
    @State private var usernameIsEditing = false
    @State private var passwordIsEditing = false
    @State private var username: String = ""
    @State private var password: String = ""
    
    init(locale: Locale) {
        logInViewModel = LogInViewModel(locale: locale)
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
        .navigationTitle("Log In")
        .apiHandler(asyncState: logInViewModel.defaultNetworkState) { _ in
            logInViewModel.loadLogInOptions()
        }
        .sheet(isPresented: $logInViewModel.singleSignOnIsPresented) {
            if logInViewModel.ssoAuthenticationState == .authenticated {
                logInViewModel.presentedAlert = .persistencePrompt
            }
        } content: {
            WebView(request: URLRequest(url: logInViewModel.ssoURL!),
                    cookieObserver: logInViewModel,
                    urlObserver: logInViewModel,
                    initialCookies: HTTPCookieStorage.shared.cookies
            )
                .apiHandler(asyncState: logInViewModel.webViewNetworkState) {
                    ProgressView("Loading")
                } retryAction: { _ in
                    logInViewModel.provisionSSOAuthentication()
                }
        }
        .alert(item: $logInViewModel.presentedAlert) { alertType in
            switch alertType {
            case .credentialError:
                let errorMessage = "Please make sure that your credentials are correct\(logInViewModel.hasSSOLogin ? " and you are using the correct log in method." : ".")"
               
                return Alert(
                        title: Text("Unable to Log In"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("Dismiss"))
                    )
            case .persistencePrompt:
                return Alert(title: Text("Stay Logged In"),
                          message: Text("Would you like \(Bundle.main.displayName ?? "us") to keep you logged in?"),
                          primaryButton: .default(Text("Not Now")) {
                                logInViewModel.setPersistence(false) {
                                    DispatchQueue.main.async {
                                        logInViewModel.authenticate(for: $applicationViewModel.authenticationState)
                                    }
                                }
                          },
                          secondaryButton: .default(Text("Yes")) {
                                logInViewModel.setPersistence(true) {
                                    DispatchQueue.main.async {
                                        logInViewModel.authenticate(for: $applicationViewModel.authenticationState)
                                    }
                                }
                         }
                    )
            }
            
        }
    }
    
    private struct DrawingConstants {
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
