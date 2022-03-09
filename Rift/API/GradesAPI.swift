//
//  GradesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    
    /// API to obtain information on grades
    struct Grades {
        
        /// Collection of endpoints to obtain information on grades
        private enum Endpoint {
            
            /// Endpoint to get all terms and their corresponding grades
            static let termGrades = "resources/portal/grades"
            
            /// Endpoint to get detail on a specific `Course`
            static let termGradeDetails = termGrades + "/detail"
        }
        
        /// Gets all terms and their corresponding grades
        /// - Parameters:
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        static func getTermGrades(locale: Locale? = nil, completion: @escaping (Result<[GradeTerm], Error>) -> Void) {
            
            API.defaultRequestManager.get(endpoint: Endpoint.termGrades, locale: locale) { result in
                switch result {
                case .success((let data, _)):
                    struct Response: Decodable {
                        
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
                case .failure(let error):
                    switch error {
                    case APIError.invalidData:
                        completion(.success([]))
                    default:
                        completion(.failure(error))
                    }
                }
                
            }
        }
        
        /// Gets detail on a specific course
        /// - Parameters:
        ///   - course: The course to get detail for
        ///   - locale: A locale that provides the district to make the call to
        ///   - completion: Completion function
        static func getGradeDetails(for course: Course, locale: Locale? = nil, completion: @escaping (Result<([Term],[GradeDetail]), Error>) -> ()) {
            API.defaultRequestManager.get(endpoint: Endpoint.termGradeDetails + "/\(course.sectionID)", locale: locale) { result in
                switch result {
                case .success((let data, _)):
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
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        }
        
    }
}
