//
//  WelcomeModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/6/21.
//

import Foundation

struct WelcomeModel {
    var chosenLocale: Locale?
    var districtSearchResults = [Locale]()
    
    mutating func resetQueries() {
        districtSearchResults = []
        chosenLocale = nil
    }
}
