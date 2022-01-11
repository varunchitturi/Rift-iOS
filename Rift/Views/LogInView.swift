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
    
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    @ObservedObject private var logInViewModel: LogInViewModel
    @State private var usernameIsEditing = false
    @State private var passwordIsEditing = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var persistenceAlertIsPresented = false
    
    init(locale: Locale) {
        // TODO: login view model is initializing multiple times due to view creation which inturn sends duplicate network requests. Make sure to only intialize this once
        logInViewModel = LogInViewModel(locale: locale)
    }
    
    var body: some View {
        VStack {
            
            ScrollView {
                Spacer(minLength: DrawingConstants.formTopSpacing)
                if logInViewModel.hasSSOLogin {
                    // TODO: have a loading state for single sign on button
                    CapsuleButton("Single Sign-On", style: .secondary) {
                        DispatchQueue.main.async {
                            usernameIsEditing = false
                            passwordIsEditing = false
                        }
                        
                        logInViewModel.promptSingleSignOn()
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
                // TODO: implement here
                print("log in")
            }
        }
        
        .padding()
        .navigationTitle("Log In")
        .apiHandler(asyncState: logInViewModel.networkState) { _ in
            logInViewModel.provisionLogInView()
        }
        .onAppear {
            logInViewModel.provisionLogInView()
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
        }
        .alert(isPresented: $persistenceAlertIsPresented) {
            Alert(title: Text("Stay Logged In"),
                  message: Text("Would you like \(Bundle.main.displayName ?? "us") to keep you logged in?"),
                  primaryButton: .default(Text("Not Now")) {
                logInViewModel.setPersistence(false)
                logInViewModel.authenticate(for: $applicationViewModel.authenticationState)
                },
                  secondaryButton: .default(Text("Yes")) {
                logInViewModel.setPersistence(true)
                logInViewModel.authenticate(for: $applicationViewModel.authenticationState)
                }
            )
        }
    }
    
    private struct DrawingConstants {
        static let dividerPadding: CGFloat = 20
        static let formTopSpacing: CGFloat = 30
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
