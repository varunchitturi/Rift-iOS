//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI


// TODO: give difference between this and Persistent Core Data. (maybe implement this better)
struct Locale: Identifiable, Codable {
    
    var id: Int
    var districtName: String
    var districtAppName: String
    var districtBaseURL: URL
    var districtCode: String
    var state: USTerritory
    var staffLogInURL: URL
    var studentLogInURL: URL
    var parentLogInURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case districtName = "district_name"
        case districtAppName = "district_app_name"
        case districtBaseURL = "district_baseurl"
        case districtCode = "district_code"
        case state = "state_code"
        case staffLogInURL = "staff_login_url"
        case studentLogInURL = "student_login_url"
        case parentLogInURL = "parent_login_url"
    }
    
    private struct API {
        static let searchDistrictEndpoint = "searchDistrict"
    }
    
    private static let baseSearchURL: URL = URL(string: "https://mobile.infinitecampus.com/mobile/")!
    
    
    private static let minimumDistrictQueryLength = 3
    
    private static func getDistrictQueryURL(query: String, state: USTerritory) -> URL? {
        let districtQuery = URLQueryItem(name: "query", value: query)
        let state = URLQueryItem(name: "state", value: state.rawValue)
        return baseSearchURL.appendingPathComponent(API.searchDistrictEndpoint).appendingQueryItems([districtQuery,state])
    }
    
    static func searchDistrict(for query: String, state: USTerritory, completion: @escaping (Result<[Locale], Error>) -> Void) {
        if query.count >= minimumDistrictQueryLength {
            guard let url = getDistrictQueryURL(query: query, state: state) else {
                completion(.failure(SearchError.invalidDistrictURL))
                return
            }
            Locale.sharedURLSession.dataTask(with: url) { data, response, error in
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
                                    locales[index].studentLogInURL.insertPathComponent(after: "portal", with: "students")
                                    locales[index].parentLogInURL.insertPathComponent(after: "portal", with: "parents")
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

}
