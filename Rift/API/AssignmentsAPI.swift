//
//  AssignmentsAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    
    /// API to get data related purely to assignments
    struct Assignments {
        
        /// Collection of endpoints for assignment requests
        private enum Endpoint {
            
            /// Endpoint for getting a list of assignments
            static let assignmentList = "api/portal/assignment/listView/"
            
            /// Endpoint for getting specific detail for an assignment
            static let assignmentDetail = "api/instruction/curriculum/sectionContent/"
        }
        
        
        /// Gets a list of all assignments
        /// - Parameters:
        ///   - locale: A locale that provides the district URL to make the call to
        ///   - completion: Completion function
        static func getList(locale: Locale? = nil, completion: @escaping (Result<[Assignment], Error>) -> ()) {
            API.defaultRequestManager.get(endpoint: Endpoint.assignmentList, locale: locale) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode([Assignment].self, from: data)
                        completion(.success(responseBody))
                    }
                    catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        }
        
        /// Gets specific detail for an `Assignment`
        /// - Parameters:
        ///   - locale: A locale that provides the district URL to make the call to
        ///   - assignment: The assignment to get detail for
        ///   - completion: Completion function
        static func getAssignmentDetail(locale: Locale? = nil, for assignment: Assignment, completion: @escaping (Result<AssignmentDetail, Error>) -> ()) {
            let id = assignment.id
            
            API.defaultRequestManager.get(endpoint: Assignments.Endpoint.assignmentDetail.appending(id.description), locale: locale) { result in
                switch result {
                case .success((let data, _)):
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode(AssignmentDetail.self, from: data)
                        completion(.success(responseBody))
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
