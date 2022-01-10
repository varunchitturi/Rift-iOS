//
//  LogInView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//

import SwiftUI
import CoreData

struct LogInView: View {
    
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    @ObservedObject private var logInViewModel: LogInViewModel
    @State private var usernameIsEditing = false
    @State private var passwordIsEditing = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var persistenceAlertIsPresented = false
    
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
                        logInViewModel.provisionAuthentication()
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
                logInViewModel.provisionAuthentication()
                print("log in")
            }
        }
        
        .padding()
        .navigationTitle("Log In")
        .apiHandler(asyncState: logInViewModel.networkState) { _ in
            logInViewModel.loadLogInOptions()
        }
        .onAppear {
            logInViewModel.loadLogInOptions()
        }
        .sheet(isPresented: $logInViewModel.singleSignOnIsPresented) {
            if logInViewModel.authenticationState == .authenticated {
                persistenceAlertIsPresented = true
            }
        }
        content: {
            WebView(request: URLRequest(url: logInViewModel.ssoURL!),
                    cookieObserver: logInViewModel,
                    urlObserver: logInViewModel,
                    initialCookies: HTTPCookieStorage.shared.cookies
            )
                .apiHandler(asyncState: logInViewModel.networkState) {
                    ProgressView("Loading")
                }
        }
        .alert(isPresented: $persistenceAlertIsPresented) {
            Alert(title: Text("Stay Logged In"),
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
