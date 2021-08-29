//
//  LogInView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//

import SwiftUI

struct LogInView: View {
    @State private var usernameTextField: String = ""
    @State private var passwordTextField: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    CapsuleButton("Single Sign-On", style: .secondary) {
                        
                    }
                    TextDivider("or")
                        
                        .padding(.vertical, DrawingConstants.dividerPadding)
                    CapsuleTextField("Username", text: $usernameTextField, icon: "person.fill", accentColor: Color("Primary"))
                    CapsuleTextField("Password", text: $passwordTextField, icon: "key.fill", accentColor: Color("Primary"))
                }
                .foregroundColor(Color("Tertiary"))
                CapsuleButton("Log In", style: .primary) {
                    
                }
            }
            .padding()
            .navigationTitle("Log In")
        }
        .navigationBarColor(backgroundColor: Color("Primary"))
    }
    
    private struct DrawingConstants {
        static let dividerPadding: CGFloat = 20
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
