//
//  Planner.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation

struct Planner {
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    let locale: Locale
    static let assignmentPathURL: URLComponents = URLComponents(string: "api/portal/assignment/listView")!
    
    func getAssignmentList(completion: @escaping (Result<[Assignment], Error>) -> ()) {
        let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Planner.assignmentPathURL.description))
        // TODO: customize this (caching mechanism for cookies and responses)
        // TODO: have a loading view for planner
        // TODO: show an network error message if no data is able to be retrieved
        // TODO: create a shared session
        URLSession(configuration: .dataLoad).dataTask(with: urlRequest) { data, response, error in
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
    
    struct Assignment: Codable, Identifiable {
        let id: Int
        let assignmentName: String
        let dueDate: Date?
        let assignedDate: Date?
        let courseName: String
        let totalPoints: Int?
        
        enum CodingKeys: String, CodingKey {
            case id = "objectSectionID"
            case assignmentName, courseName, totalPoints, dueDate, assignedDate
        }
        
        init(id: Int, assignmentName: String, dueDate: Date?, assignedDate: Date?, courseName: String, totalPoints: Int?) {
            self.id = id
            self.assignmentName = assignmentName
            self.dueDate = dueDate
            self.assignedDate = assignedDate
            self.courseName = courseName
            self.totalPoints = totalPoints
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let id = try container.decode(Int.self, forKey: .id)
            let assignmentName = try container.decode(String.self, forKey: .assignmentName)
            let courseName = try container.decode(String.self, forKey: .courseName)
            let totalPoints = try container.decode(Int?.self, forKey: .totalPoints)
            let dueDateString = try (container.decode(String?.self, forKey: .dueDate))
            let assignedDateString = try container.decode(String?.self, forKey: .assignedDate)
            
            let dateDecoder = JSONDecoder()
            dateDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso180601Full)
            
            let dueDate = dueDateString != nil ? DateFormatter.iso180601Full.date(from: dueDateString!) : nil
            let assignedDate = assignedDateString != nil ? DateFormatter.iso180601Full.date(from: assignedDateString!) : nil
            self.init(id: id, assignmentName: assignmentName, dueDate: dueDate, assignedDate: assignedDate, courseName: courseName, totalPoints: totalPoints)
        }
    }
}
