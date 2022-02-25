//
//  WelcomeModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/6/21.
//

import Foundation

/// MVVM model to handle the `WelcomeView`
struct WelcomeModel {
    
    /// The selected locale in the `WelcomeView`
    var chosenLocale: Locale?
    
    /// Array of `Locale`s that matches the user's query
    var districtSearchResults = [Locale]()
    
    /// Resets the chosen locale and locale search results
    mutating func resetQueries() {
        districtSearchResults = []
        chosenLocale = nil
    }
}
