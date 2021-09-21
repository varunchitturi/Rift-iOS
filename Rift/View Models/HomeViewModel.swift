//
//  HomeViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var settingsIsPresented: Bool
    @Published var locale: Locale
    
    init(locale: Locale) {
        self.locale = locale
        self.settingsIsPresented = false
    }
}
