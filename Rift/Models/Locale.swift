//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation

struct Locale: Identifiable, Codable {
    let id: Int
    let districtName: String
    let districtAppName: String
    let districtBaseURL: URL
    let districtCode: String
    let state: USTerritory
    let staffLoginURL: URL
    let userLoginURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case districtName = "district_name"
        case districtAppName = "district_app_name"
        case districtBaseURL = "district_baseurl"
        case districtCode = "district_code"
        case state = "state_code"
        case staffLoginURL = "staff_login_url"
        case userLoginURL = "student_login_url"
    }
    
    private static let ICDistrictQueryURLPrefix = "https://mobile.infinitecampus.com/mobile/searchDistrict?"
    
    private static let minimumDistrictQueryLength = 3
    
    private static func getDistrictQueryURL(query: String, state: String) -> URL? {
        return URL(string: Locale.ICDistrictQueryURLPrefix + "query=\(query)&state=\(state)")
    }
    
    static func searchDistrict(for query: String, state: USTerritory, completion: @escaping (Result<[Locale], Error>) -> Void) {
        if query.count >= minimumDistrictQueryLength {
            guard let url = getDistrictQueryURL(query: query, state: state.rawValue) else {
                completion(.failure(SearchError.invalidDistrictURL))
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                DispatchQueue.main.async {
                    do {
                        if let data = data {
                            let decoder = JSONDecoder()
                            let localesData = try decoder.decode([String: [Locale]].self, from: data)
                            print(localesData)
                            if let locales = localesData["data"] {
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
                        completion(.failure(error))
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
