//
//  Welcome.swift
//  Rift
//
//  Created by Varun Chitturi on 10/6/21.
//

import Foundation

struct Welcome {
    var chosenLocale: Locale?
    var districtSearchResults = [Locale]()
    
    mutating func resetQueries() {
        districtSearchResults = []
        chosenLocale = nil
    }
}
