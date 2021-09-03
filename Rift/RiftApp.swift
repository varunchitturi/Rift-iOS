//
//  RiftApp.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
//

import SwiftUI

@main
struct RiftApp: App {
    
    // TODO: Delete these
    @State var text = NSMutableAttributedString(string: "")
    @State var autocompletePossibilites: [String] = ["Autocomplete", "Autofill"]
    
    var body: some Scene {
        // TODO: Change status bar color
        
        WindowGroup {
           CapsuleAutoCompleteField(text: $text, autocompletePossibilites: $autocompletePossibilites, minimumQueryLength: 3, accentColor: Color("Primary"), label: "Auto")
        }
    }
}
