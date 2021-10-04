//
//  HomeViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var settingsIsPresented: Bool
    
    init() {
        self.settingsIsPresented = false
    }
    
}
