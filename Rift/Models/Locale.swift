//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation

struct Locale {
    var state: String
    var district: String
    
    var stateAbbreviation: String? {
        LocaleUtils.USStates[state]
    }

}
