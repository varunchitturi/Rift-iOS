//
//  Planner.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation

struct Planner {
    
    let locale = PersistentLocale.getLocale()
    
    func getAssignmentList(completion: @escaping (Result<[Assignment], Error>) -> ()) {
        guard let locale = locale else { return }
        let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Planner.API.assignmentEndpoint))
        // TODO: customize this (caching mechanism for cookies and responses)
        // TODO: have a loading view for planner
        // TODO: show an network error message if no data is able to be retrieved
        // TODO: create a shared session
        Planner.sharedURLSession.dataTask(with: urlRequest) { data, response, error in
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
                    catch(let error) {
                        completion(.failure(error))
                    }
                }
            }
            else {
                completion(.failure(PlannerNetworkError.invalidData))
            }
        }.resume()
    }
    
    enum PlannerNetworkError: Error {
        case invalidData
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Invalid or no data for assignment"
            }
        }
    }
    
}
