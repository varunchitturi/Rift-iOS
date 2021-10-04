//
//  Courses.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation


struct Courses {
    
    typealias Course = API.Course
    
    var courseList = [Course]()
    let locale = PersistentLocale.getLocale()
    
    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        guard let locale = locale else { return }
        let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(API.Endpoint.grades.endpointPath))
        // TODO: customize this (caching mechanism for cookies and responses)
        // TODO: have a loading view for courses
        // TODO: show an network error message if no data is able to be retrieved
        // TODO: create a shared session
        Courses.sharedURLSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let gradesResponse = try decoder.decode(API.Endpoint.GradesResponse, from: data)
                        if !gradesResponse.isEmpty && gradesResponse.first!.terms.count > 0 {
                            // TODO: choose terms based on start and end date
                            completion(.success(gradesResponse.first!.terms[0].courses))
                        }
                        else {
                            completion(.failure(CourseNetworkError.invalidData))
                        }
                        
                    }
                    
                    catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
            else {
                completion(.failure(CourseNetworkError.invalidData))
            }
        }.resume()
    }
    
    enum CourseNetworkError: Error {
        case invalidData
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Invalid or no data for courses"
            }
        }
    }
    
}

