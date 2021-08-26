//
//  ContentView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct WelcomeView: View {
    @State private var selectionIndex: Int?
    var body: some View {
        CapsuleDropDown("DropDown",description: "Pick an option", options: ["Option 1", "Option 2", "Option 3"], selectionIndex: $selectionIndex)
            .padding()
        
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
