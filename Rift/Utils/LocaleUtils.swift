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
    
    static let USStates: [String : String] = [
        "AK" : "Alaska",
        "AL" : "Alabama",
        "AR" : "Arkansas",
        "AS" : "American Samoa",
        "AZ" : "Arizona",
        "CA" : "California",
        "CO" : "Colorado",
        "CT" : "Connecticut",
        "DC" : "District of Columbia",
        "DE" : "Delaware",
        "FL" : "Florida",
        "GA" : "Georgia",
        "GU" : "Guam",
        "HI" : "Hawaii",
        "IA" : "Iowa",
        "ID" : "Idaho",
        "IL" : "Illinois",
        "IN" : "Indiana",
        "KS" : "Kansas",
        "KY" : "Kentucky",
        "LA" : "Louisiana",
        "MA" : "Massachusetts",
        "MD" : "Maryland",
        "ME" : "Maine",
        "MI" : "Michigan",
        "MN" : "Minnesota",
        "MO" : "Missouri",
        "MS" : "Mississippi",
        "MT" : "Montana",
        "NC" : "North Carolina",
        "ND" : " North Dakota",
        "NE" : "Nebraska",
        "NH" : "New Hampshire",
        "NJ" : "New Jersey",
        "NM" : "New Mexico",
        "NV" : "Nevada",
        "NY" : "New York",
        "OH" : "Ohio",
        "OK" : "Oklahoma",
        "OR" : "Oregon",
        "PA" : "Pennsylvania",
        "PR" : "Puerto Rico",
        "RI" : "Rhode Island",
        "SC" : "South Carolina",
        "SD" : "South Dakota",
        "TN" : "Tennessee",
        "TX" : "Texas",
        "UT" : "Utah",
        "VA" : "Virginia",
        "VI" : "Virgin Islands",
        "VT" : "Vermont",
        "WA" : "Washington",
        "WI" : "Wisconsin",
        "WV" : "West Virginia",
        "WY" : "Wyoming"]
    
    private static func districtQueryGenerator() -> [String] {
        let minimumQuerySize = 3
        var queries = [String]()
        let alphabet = Array((Character("a").asciiValue!...Character("z").asciiValue!)).map ({Character(UnicodeScalar($0))})
        for perm in alphabet.permutations(ofCount: minimumQuerySize) {
            queries.append(String(perm))
        }
        return queries
    }
    
    private static func districtQueryURL(state: String, query: String) -> URL? {
        return URL(string: ICDistrictQueryURLPrefix + "query=\(query)&state=\(state)")
    }
    
    static func getDistricts(for state: String) {
        let requestGroup = DispatchGroup()
        let queries = districtQueryGenerator()
        let urlSession = URLSession.shared
        var urlRequests: [URLRequest] = []
        
        for query in queries {
            if let url = districtQueryURL(state: state, query: query) {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                urlRequests.append(URLRequest(url: url))
            }
        }
        for request in urlRequests {
            requestGroup.enter()
            let task = urlSession.dataTask(with: request) {data, response, error in
                
                if let error = error {
                    print("fail")
                } else if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                                print(jsonString)
                             }
                } else {
                    print("fail")
                }
                requestGroup.leave()
            }
            task.resume()
        }
        requestGroup.notify(queue: .main) {
            print("done")
        }
        

    }
}
