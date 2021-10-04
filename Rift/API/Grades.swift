//
//  Grades.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    
    struct Grades {
        private static let gradesEndpoint = "resources/portal/grades"
        
        func getCourses(locale: Locale, completion: @escaping (Result<[Course], Error>) -> Void) {
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Grades.gradesEndpoint))
            // TODO: customize this (caching mechanism for cookies and responses)
            // TODO: have a loading view for courses
            // TODO: show an network error message if no data is able to be retrieved
            // TODO: create a shared session
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let decoder = JSONDecoder()
                            let gradesResponse = try decoder.decode([Grades.GradesResponse].self, from: data)
                            if !gradesResponse.isEmpty && gradesResponse.first!.terms.count > 0 {
                                // TODO: choose terms based on start and end date
                                completion(.success(gradesResponse.first!.terms[0].courses))
                            }
                            else {
                                completion(.failure(APIError.invalidData))
                            }
                            
                        }
                        catch {
                            print(error.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    completion(.failure(APIError.invalidData))
                }
            }.resume()
        }
        
        private struct GradesResponse: Codable {
            let terms: [Term]
            
            struct Term: Codable {
                let courses: [API.Course]
            }
            
        }
    }
    
    
    
    
}
