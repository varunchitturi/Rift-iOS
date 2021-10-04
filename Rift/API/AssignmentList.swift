//
//  AssignmentList.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    struct AssignmentList {
        private static let assignmentListEndpoint = "api/portal/assignment/listView"
        static let responseType = Array<API.Assignment>.self
        
        func get(locale: Locale, completion: @escaping (Result<[Assignment], Error>) -> ()) {
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(API.AssignmentList.assignmentListEndpoint))
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    DispatchQueue.main.async {
                        do {
                            let decoder = JSONDecoder()
                            let assignmentResponse = try decoder.decode([Assignment].self, from: data)
                            completion(.success(assignmentResponse))
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
    }
}
