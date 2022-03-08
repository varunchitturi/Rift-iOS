//
//  DistrictSearchAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation


extension API {
    
    /// API to search for a user's district
    struct DistrictSearch {
        
        /// Collection of endpoints to support district search
        enum Endpoint {
            
            /// Endpoint to search for districts
            static let districtSearch = "searchDistrict"
        }
        
        /// Base URL for searching districts
        private static let baseSearchURL: URL = URL(string: "https://mobile.infinitecampus.com/mobile/")!
        
        /// Minimum characters needed to make a search query
        /// - Infinite Campus requires a minimum number of characters to make a search
        private static let minimumDistrictQueryLength = 3
        
        /// Creates a URL for a district search query
        /// - Parameters:
        ///   - query: The search query
        ///   - state:The state or territory to search for districts in
        /// - Returns: The URL for the search query
        private static func getDistrictQueryURL(query: String, state: Locale.USTerritory) -> URL? {
            let districtQuery = URLQueryItem(name: "query", value: query)
            let state = URLQueryItem(name: "state", value: state.rawValue)
            return DistrictSearch.baseSearchURL.appendingPathComponent(Endpoint.districtSearch).appendingQueryItems([districtQuery,state])
        }
        
        /// Gets all districts that satisfy a certain query
        /// - Parameters:
        ///   - query: The search query
        ///   - state: The state or territory to search for districts in
        ///   - completion: An array of `Locale`s that represent districts
        static func searchDistrict(for query: String, state: Locale.USTerritory, completion: @escaping (Result<[Locale], Error>) -> Void) {
            if query.count >= DistrictSearch.minimumDistrictQueryLength {
                guard let url = getDistrictQueryURL(query: query, state: state) else {
                    return completion(.failure(APIError.invalidRequest))
                }
                
                API.defaultRequestManager.get(url: url) { result in
                    switch result {
                    case .success((let data, _)):
                        do {
                            let decoder = JSONDecoder()
                            let localesData = try decoder.decode([String: [Locale]].self, from: data)
                            var locales = localesData["data"] ?? []
                            for index in locales.indices {
                                locales[index].studentLogInURL.insertPathComponent(after: "portal", with: "students")
                                locales[index].parentLogInURL.insertPathComponent(after: "portal", with: "parents")
                            }
                            completion(.success(locales))
                        }
                        catch {
                            completion(.success([]))
                        }
                    case .failure(_):
                        completion(.success([]))
                    }
                    
                    
                }
            }
            else {
                completion(.success([]))
            }
            
        }
    }
}


