//
//  DistrictSearchAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation


extension API {
    
    struct DistrictSearch {
        
        enum Endpoint {
            static let districtSearch = "searchDistrict"
        }
        
        private static let baseSearchURL: URL = URL(string: "https://mobile.infinitecampus.com/mobile/")!
        
        private static let minimumDistrictQueryLength = 3
        
        private static func getDistrictQueryURL(query: String, state: Locale.USTerritory) -> URL? {
            let districtQuery = URLQueryItem(name: "query", value: query)
            let state = URLQueryItem(name: "state", value: state.rawValue)
            return DistrictSearch.baseSearchURL.appendingPathComponent(Endpoint.districtSearch).appendingQueryItems([districtQuery,state])
        }
        
        static func searchDistrict(for query: String, state: Locale.USTerritory, completion: @escaping (Result<[Locale], Error>) -> Void) {
            if query.count >= DistrictSearch.minimumDistrictQueryLength {
                guard let url = getDistrictQueryURL(query: query, state: state) else {
                    return completion(.failure(APIError.invalidRequest))
                }
                API.defaultURLSession.dataTask(with: url) { data, response, error in
                    if let error = (error ?? APIError(response: response)) {
                        completion(.failure(error))
                    }
                    else if let data = data {
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
                            completion(.failure(error))
                        }
                    }
                    else {
                        completion(.failure(APIError.invalidData))
                    }
                }.resume()
            }
            else {
                completion(.success([]))
            }
            
        }
    }
}


