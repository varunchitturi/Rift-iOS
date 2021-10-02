//
//  Courses.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation


struct Courses {
    var courseList = [Course]()
    let locale: Locale
    
    init(locale: Locale) {
        self.locale = locale
    }
    
    func getCourses(completion: @escaping (Result<[Course], Error>) -> Void) {
        let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Courses.API.coursesEndpoint))
        // TODO: customize this (caching mechanism for cookies and responses)
        // TODO: have a loading view for courses
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
                        let gradesResponse = try decoder.decode([GradesResponse].self, from: data)
                        if gradesResponse.count > 0 && gradesResponse[0].terms.count > 0{
                            // TODO: choose terms based on start and end date
                            completion(.success(gradesResponse[0].terms[0].courses))
                        }
                        else {
                            completion(.failure(CourseNetworkError.invalidData))
                        }
                        
                    }
                    catch(let error) {
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
    
    private struct GradesResponse: Codable {
        let terms: [Term]
    }
    private struct Term: Codable {
        let courses: [Course]
        // TODO: get start and end date of term
    }
    struct Course: Codable, Identifiable {
        
        init(id: Int, courseName: String, teacherName: String, grades: [Courses.Grade]?, isDropped: Bool) {
            self.id = id
            self.courseName = courseName
            self.teacherName = teacherName
            self.grades = grades
            self.isDropped = isDropped
        }
        
        let id: Int
        let courseName: String
        let teacherName: String?
        let grades: [Grade]?
        let isDropped: Bool
        
        var gradeDisplay: Courses.Grade? {
            // TODO: use the correct term by start and end date
            grades?[0]
        }
        
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case courseName
            case teacherName = "teacherDisplay"
            case isDropped = "dropped"
            case grades = "gradingTasks"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let idString = try container.decode(String.self, forKey: .id)
            let id = Int(idString)!
            let courseName = try container.decode(String.self, forKey: .courseName)
            let isDropped =  try container.decode(Bool.self, forKey: .isDropped)
            let grades = try container.decode([Grade]?.self, forKey: .grades)
            let teacherName = try container.decode(String.self, forKey: .teacherName)
            self.init(id: id, courseName: courseName, teacherName: teacherName, grades: grades, isDropped: isDropped)
        }

    }
    
    struct Grade: Codable {
        let letterGrade: String?
        let percentage: Double?
        let currentPoints: Double?
        let totalPoints: Double?
        let termName: String
        let termType: TermType
        
        var percentageString: String {
            guard let percentage = percentage?.description else {
                if let totalPoints = totalPoints, let currentPoints = currentPoints {
                    return (((currentPoints / totalPoints) * 100).rounded() * 100).description.appending("%")
                } else {
                    return "-"
                }
            }
            return percentage.appending("%")
        }
        
        enum CodingKeys: String, CodingKey {
            case letterGrade = "progressScore"
            case percentage = "progressPercent"
            case currentPoints = "progressPointsEarned"
            case totalPoints = "progressTotalPoints"
            case termName
            case termType = "taskName"
        }
    }
    enum TermType: String, Codable {
        case midTerm = "Mid-Term Grade"
        case quarter = "Quarter Grade"
        case semester = "Semester Final"
    }
}

