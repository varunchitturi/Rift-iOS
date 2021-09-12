//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI

struct Locale: Identifiable, Codable {
    
    var id: Int
    var districtName: String
    var districtAppName: String
    var districtBaseURL: URL
    var districtCode: String
    var state: USTerritory
    var staffLoginURL: URL
    var studentLoginURL: URL
    var parentLoginURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case districtName = "district_name"
        case districtAppName = "district_app_name"
        case districtBaseURL = "district_baseurl"
        case districtCode = "district_code"
        case state = "state_code"
        case staffLoginURL = "staff_login_url"
        case studentLoginURL = "student_login_url"
        case parentLoginURL = "parent_login_url"
    }
    
    private static let baseURL: URLComponents = URLComponents(string: "https://mobile.infinitecampus.com/mobile/searchDistrict")!
    
    private static let minimumDistrictQueryLength = 3
    
    private static func getDistrictQueryURL(query: String, state: USTerritory) -> URL? {
        let query = URLQueryItem(name: "query", value: query)
        let state = URLQueryItem(name: "state", value: state.rawValue)
        var queryURL = baseURL
        queryURL.queryItems = [query, state] 
        return queryURL.url
    }
    
    static func searchDistrict(for query: String, state: USTerritory, completion: @escaping (Result<[Locale], Error>) -> Void) {
        if query.count >= minimumDistrictQueryLength {
            guard let url = getDistrictQueryURL(query: query, state: state) else {
                completion(.failure(SearchError.invalidDistrictURL))
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                DispatchQueue.main.async {
                    do {
                        if let data = data {
                            let decoder = JSONDecoder()
                            let localesData = try decoder.decode([String: [Locale]].self, from: data)
                            
                            if var locales = localesData["data"] {
                                for index in locales.indices {
                                    locales[index].studentLoginURL.insertPathComponent(after: "portal", with: "students")
                                    locales[index].parentLoginURL.insertPathComponent(after: "portal", with: "parents")
                                }
                                completion(.success(locales))
                            }
                            else {
                                completion(.success([]))
                            }
                        }
                        else {
                            completion(.failure(SearchError.noData))
                        }
                    } catch {
                        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                            completion(.success([]))
                        }
                        else {
                            completion(.failure(error))
                        }
                    }
                }
            }.resume()
        }
        else {
            completion(.success([]))
        }
        
    }
    
    enum SearchError: Error, LocalizedError {
        case invalidDistrictURL
        case noData
        var errorDescription: String? {
            switch self {
            case .invalidDistrictURL:
                 return "Error creating district query URL"
            case .noData:
                return "No data from URL response"
            }
            
        }
    }
    
    enum USTerritory: String, CaseIterable, Comparable, Codable {
        static func < (lhs: USTerritory, rhs: USTerritory) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        var description: String {
            USTerritory.stateDescriptionDict[self.rawValue]!
        }
        
        case AL, AK, AS, AZ, AR, CA, CO, CT, DE, DC, FM, FL, GA, GU, HI, ID, IL, IN, IA, KS, KY, LA, ME, MH, MD, MA, MI, MN, MS, MO, MT, NE, NV, NH, NJ, NM, NY, NC, ND, MP, OH, OK, OR, PW, PA, PR, RI, SC, SD, TN, TX, UT, VT, VI, VA, WA, WV, WI, WY
        
        private static let stateDescriptionDict =  [
            "AL": "Alabama",
            "AK": "Alaska",
            "AS": "American Samoa",
            "AZ": "Arizona",
            "AR": "Arkansas",
            "CA": "California",
            "CO": "Colorado",
            "CT": "Connecticut",
            "DE": "Delaware",
            "DC": "District Of Columbia",
            "FM": "Federated States Of Micronesia",
            "FL": "Florida",
            "GA": "Georgia",
            "GU": "Guam",
            "HI": "Hawaii",
            "ID": "Idaho",
            "IL": "Illinois",
            "IN": "Indiana",
            "IA": "Iowa",
            "KS": "Kansas",
            "KY": "Kentucky",
            "LA": "Louisiana",
            "ME": "Maine",
            "MH": "Marshall Islands",
            "MD": "Maryland",
            "MA": "Massachusetts",
            "MI": "Michigan",
            "MN": "Minnesota",
            "MS": "Mississippi",
            "MO": "Missouri",
            "MT": "Montana",
            "NE": "Nebraska",
            "NV": "Nevada",
            "NH": "New Hampshire",
            "NJ": "New Jersey",
            "NM": "New Mexico",
            "NY": "New York",
            "NC": "North Carolina",
            "ND": "North Dakota",
            "MP": "Northern Mariana Islands",
            "OH": "Ohio",
            "OK": "Oklahoma",
            "OR": "Oregon",
            "PW": "Palau",
            "PA": "Pennsylvania",
            "PR": "Puerto Rico",
            "RI": "Rhode Island",
            "SC": "South Carolina",
            "SD": "South Dakota",
            "TN": "Tennessee",
            "TX": "Texas",
            "UT": "Utah",
            "VT": "Vermont",
            "VI": "Virgin Islands",
            "VA": "Virginia",
            "WA": "Washington",
            "WV": "West Virginia",
            "WI": "Wisconsin",
            "WY": "Wyoming"
          ]
    }

}
