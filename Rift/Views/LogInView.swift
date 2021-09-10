//
//  LogInView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject private var logInViewModel: LogInViewModel
    @State private var usernameIsEditing = false
    @State private var passwordIsEditing = false
    
    init(locale: Locale) {
        logInViewModel = LogInViewModel(locale: locale)
    }
    
    var body: some View {
        VStack {
            
            ScrollView {
                Spacer(minLength: DrawingConstants.formTopSpacing)
                if logInViewModel.hasSSOLogin {
                    CapsuleButton("Single Sign-On", style: .secondary) {
                        
                    }
                    TextDivider("or")
                        .padding(.vertical, DrawingConstants.dividerPadding)
                    Spacer()
                }
                
                Spacer()
                CapsuleTextField("Username", text: $logInViewModel.username, isEditing: $usernameIsEditing, icon: "person.fill", accentColor: DrawingConstants.accentColor, configuration: LegacyTextField.customInputConfiguration)
                    
                CapsuleTextField("Password", text: $logInViewModel.password, isEditing: $passwordIsEditing, icon: "key.fill", accentColor: DrawingConstants.accentColor, isSecureStyle: true, configuration: LegacyTextField.customInputConfiguration)
            }
            .foregroundColor(DrawingConstants.fieldForegroundColor)
            Spacer()
            CapsuleButton("Log In", style: .primary) {
                print("log in")
            }
        }
        .padding()
        .navigationTitle("Log In")
    }
    
    private struct DrawingConstants {
        static let dividerPadding: CGFloat = 20
        static let formTopSpacing: CGFloat = 30
        static let fieldForegroundColor = Color("Tertiary")
        static let accentColor = Color("Primary")
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(locale: Locale(id: 1, districtName: "District Name", districtAppName: "FUSD", districtBaseURL: URL(string: "https://")!, districtCode: "fusd", state: .CA, staffLoginURL: URL(string: "https://")!, studentLoginURL: URL(string: "https://")!, parentLoginURL: URL(string: "https://")!))
    }
}
