//
//  ContentView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationView {
            CapsuleButton(description: "Next", icon: "arrow.right", type: .primary) {
                
            }
                .navigationTitle("Welcome.")
        }
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .previewDevice("iPhone 11")
        WelcomeView()
            .previewDevice("iPhone SE (2nd generation)")
    }
}
