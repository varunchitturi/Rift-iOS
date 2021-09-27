//
//  ApplicationViewModel.swift
//  ApplicationViewModel
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

class ApplicationViewModel: ObservableObject {
    @Published private var application = Application(authenticationState: false)
    
    var isAuthenticated: Bool {
        get {
            application.authenticationState
        }
        set {
            application.authenticationState = newValue
        }
        
    }
}
