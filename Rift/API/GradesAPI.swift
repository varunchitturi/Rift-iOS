//
//  GradesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    
    struct Grades {
        
        private enum Endpoint {
            static let termGrades = "resources/portal/grades"
            static let termGradeDetails = termGrades + "/detail"
        }
        
        static func getTermGrades(locale: Locale? = nil, completion: @escaping (Result<[GradeTerm], Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(APIError.invalidLocale))
                return
            }
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
                    struct Response: Decodable {
                        // TODO: use custom term here
                        let gradeTerms: [GradeTerm]
                        
                        enum CodingKeys: String, CodingKey {
                            case gradeTerms = "terms"
                        }
                   }
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode([Response].self, from: data)
                        !responseBody.isEmpty ? completion(.success(responseBody[0].gradeTerms)) : completion(.failure(APIError.invalidData))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.success([]))
                }
            }.resume()
        }
        
        static func getGradeDetails(for assignmentID: Int, locale: Locale? = nil, completion: @escaping (Result<([Term],[GradeDetail]), Error>) -> ()) {
            
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(APIError.invalidLocale))
                return
            }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.termGradeDetails + "/\(assignmentID)"))
            
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    struct Response: Decodable {
                        let terms: [Term]
                        var gradeDetails: [GradeDetail]
                        
                        enum CodingKeys: String, CodingKey {
                            case terms
                            case gradeDetails = "details"
                        }
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        var response = try decoder.decode(Response.self, from: data)
                        response.gradeDetails.resolveCategories()
                        response.gradeDetails.resolveTerms()
                        completion(.success((response.terms, response.gradeDetails)))
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
        
    }
}
