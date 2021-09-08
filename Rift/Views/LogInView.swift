//
//  LogInView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//

import SwiftUI

struct LogInView: View {
    @State private var usernameTextField = ""
    @State private var passwordTextField = ""
    @State private var usernameIsEditing = false
    @State private var passwordIsEditing = false
    var body: some View {
        VStack {
            ScrollView {
                Spacer(minLength: DrawingConstants.formTopSpacing)
                CapsuleButton("Single Sign-On", style: .secondary) {
                    
                }
                TextDivider("or")
                    .padding(.vertical, DrawingConstants.dividerPadding)
                Spacer()
                Spacer()
                CapsuleTextField("Username", text: $usernameTextField, isEditing: $usernameIsEditing, icon: "person.fill", accentColor: Color("Primary"), configuration: LegacyTextField.customInputConfiguration)
                    
                CapsuleTextField("Password", text: $passwordTextField, isEditing: $passwordIsEditing, icon: "key.fill", accentColor: Color("Primary"), isSecureStyle: true, configuration: LegacyTextField.customInputConfiguration)
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
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
