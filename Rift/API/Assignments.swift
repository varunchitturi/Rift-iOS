//
//  Assignments.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    struct Assignments {
        
        private enum Endpoint {
            static let assignmentList = "api/portal/assignment/listView"
        }
        
        
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
    }
}
