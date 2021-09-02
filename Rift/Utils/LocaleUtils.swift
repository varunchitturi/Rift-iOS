//
//  LocaleUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 8/29/21.
//

import Foundation
import Algorithms

struct LocaleUtils {
    
    private static let ICDistrictQueryURLPrefix = "https://mobile.infinitecampus.com/mobile/searchDistrict?"
    static let minimumDistrictQueryLength = 3
    
    static let USStates = ["Alabama": "AL",
                           "Alaska": "AK",
                           "Arizona": "AZ",
                           "Arkansas": "AR",
                           "California": "CA",
                           "Colorado": "CO",
                           "Connecticut": "CT",
                           "Delaware": "DE",
                           "Florida": "FL",
                           "Georgia": "GA",
                           "Hawaii": "HI",
                           "Idaho": "ID",
                           "Illinois": "IL",
                           "Indiana": "IN",
                           "Iowa": "IA",
                           "Kansas": "KS",
                           "Kentucky": "KY",
                           "Louisiana": "LA",
                           "Maine": "ME",
                           "Maryland": "MD",
                           "Massachusetts": "MA",
                           "Michigan": "MI",
                           "Minnesota": "MN",
                           "Mississippi": "MS",
                           "Missouri": "MO",
                           "Montana": "MT",
                           "Nebraska": "NE",
                           "Nevada": "NV",
                           "New Hampshire": "NH",
                           "New Jersey": "NJ",
                           "New Mexico": "NM",
                           "New York": "NY",
                           "North Carolina": "NC",
                           "North Dakota": "ND",
                           "Ohio": "OH",
                           "Oklahoma": "OK",
                           "Oregon": "OR",
                           "Pennsylvania": "PA",
                           "Rhode Island": "RI",
                           "South Carolina": "SC",
                           "South Dakota": "SD",
                           "Tennessee": "TN",
                           "Texas": "TX",
                           "Utah": "UT",
                           "Vermont": "VT",
                           "Virginia": "VA",
                           "Washington": "WA",
                           "West Virginia": "WV",
                           "Wisconsin": "WI",
                           "Wyoming": "WY"]
    
    private static func districtQueryURL(state: String, query: String) -> URL? {
        return URL(string: ICDistrictQueryURLPrefix + "query=\(query)&state=\(state)")
    }

}
