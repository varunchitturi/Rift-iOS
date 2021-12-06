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
        
        // TODO: make all dispatch queue .main.async calls from the view model only. API should not have access to the main thread.
        static func getList(locale: Locale? = nil, completion: @escaping (Result<[Assignment], Error>) -> ()) {
            guard let locale = locale ?? PersistentLocale.getLocale() else { return }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Assignments.Endpoint.assignmentList))
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let decoder = JSONDecoder()
                            let responseBody = try decoder.decode([Assignment].self, from: data)
                            completion(.success(responseBody))
                        }
                        catch {
                            completion(.failure(error))
                        }
                    }
                }
                else {
                    completion(.failure(APIError.invalidData))
                }
            }.resume()
        }
        // TODO: remove dispatchqueue.main.async from api
        static func getAssignmentDetail(locale: Locale? = nil, for assignment: Assignment, completion: @escaping (Result<AssignmentDetail, Error>) -> ()) {
            let id = assignment.id
            guard let locale = locale ?? PersistentLocale.getLocale() else { return }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Assignments.Endpoint.assignmentDetail.appending(id.description)))
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    }
                    else if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                let responseBody = try decoder.decode(AssignmentDetail.self, from: data)
                                completion(.success(responseBody))
                            }
                            catch {
                                completion(.failure(error))
                            }
                        
                    }
                    else {
                        completion(.failure(APIError.invalidData))
                    }
                }
                
            }.resume()
        }
    }
}
