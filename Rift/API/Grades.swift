//
//  Grades.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    
    struct Grades {
        
        private enum Endpoint {
            static let termGrades = "resources/portal/grades"
        }
        
        static func getTermGrades(locale: Locale? = nil, completion: @escaping (Result<[Term], Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else { return }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.termGrades))
            // TODO: customize this (caching mechanism for cookies and responses)
            // TODO: have a loading view for courses
            // TODO: show an network error message if no data is able to be retrieved
            // TODO: create a shared session
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    
                    struct Response: Codable {
                       let terms: [Term]
                   }
                    
                    DispatchQueue.main.async {
                        do {
                            let decoder = JSONDecoder()
                            let responseBody = try decoder.decode(Response.self, from: data)
                            completion(.success(responseBody.terms))
                        }
                        catch {
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    completion(.success([]))
                }
            }.resume()
        }
        
        
    }
    
    
    
    
}
