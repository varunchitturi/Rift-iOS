//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation

struct Locale {
    var id: Int
    var districtName: String
    var districtAppName: String
    var districtBaseURL: URL
    var districtCode: String
    var state: LocaleUtils.USTerritory
    var staffLoginURL: URL
    var userLoginURL: URL
}
