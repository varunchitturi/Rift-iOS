//
//  UserPreferences.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import Foundation
import SwiftUI


struct UserPreferences {
    
    static let shared: [PreferenceGroup] = [
        PreferenceGroup(label: "User", preferences: [
            PreferenceItem(label: "Log Out", viewConfiguration: Text("hello")) { authenticationState in
                if let isAuthenticated = authenticationState as? Binding<Bool> {
                    isAuthenticated.wrappedValue = false
                }
            }
                                                    
        ])
    ]
    
    struct PreferenceItem: Identifiable {
        let label: String
        var id: Int {
            label.hashValue
        }
        let action: (Any) -> ()
    }
    
    struct PreferenceGroup: Identifiable {
        let label: String
        var id: Int {
            label.hashValue
        }
        let preferences: [PreferenceItem]
    }
}
