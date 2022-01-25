//
//  AssignmentsAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    struct Assignments {
        
        private enum Endpoint {
            static let assignmentList = "api/portal/assignment/listView/"
            static let assignmentDetail = "api/instruction/curriculum/sectionContent/"
        }
        
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
