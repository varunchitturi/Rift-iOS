//
//  LocaleUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 8/29/21.
//

import Foundation
import Algorithms

struct LocaleUtils {
    
    private static let ICDistrictQueryURLPrefix = "https =//mobile.infinitecampus.com/mobile/searchDistrict?"
    
    private static let minimumDistrictQueryLength = 3
    
    enum USTerritory: String, CaseIterable, Comparable {
        static func < (lhs: LocaleUtils.USTerritory, rhs: LocaleUtils.USTerritory) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case AL = "Alabama",
        AK = "Alaska",
        AS = "American Samoa",
        AZ = "Arizona",
        AR = "Arkansas",
        CA = "California",
        CO = "Colorado",
        CT = "Connecticut",
        DE = "Delaware",
        DC = "District Of Columbia",
        FM = "Federated States Of Micronesia",
        FL = "Florida",
        GA = "Georgia",
        GU = "Guam",
        HI = "Hawaii",
        ID = "Idaho",
        IL = "Illinois",
        IN = "Indiana",
        IA = "Iowa",
        KS = "Kansas",
        KY = "Kentucky",
        LA = "Louisiana",
        ME = "Maine",
        MH = "Marshall Islands",
        MD = "Maryland",
        MA = "Massachusetts",
        MI = "Michigan",
        MN = "Minnesota",
        MS = "Mississippi",
        MO = "Missouri",
        MT = "Montana",
        NE = "Nebraska",
        NV = "Nevada",
        NH = "New Hampshire",
        NJ = "New Jersey",
        NM = "New Mexico",
        NY = "New York",
        NC = "North Carolina",
        ND = "North Dakota",
        MP = "Northern Mariana Islands",
        OH = "Ohio",
        OK = "Oklahoma",
        OR = "Oregon",
        PW = "Palau",
        PA = "Pennsylvania",
        PR = "Puerto Rico",
        RI = "Rhode Island",
        SC = "South Carolina",
        SD = "South Dakota",
        TN = "Tennessee",
        TX = "Texas",
        UT = "Utah",
        VT = "Vermont",
        VI = "Virgin Islands",
        VA = "Virginia",
        WA = "Washington",
        WV = "West Virginia",
        WI = "Wisconsin",
        WY = "Wyoming"
    }
    
    private static func districtQueryURL(state: String, query: String) -> URL? {
        return URL(string: ICDistrictQueryURLPrefix + "query=\(query)&state=\(state)")
    }
    

}
