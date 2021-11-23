//
//  GradesAPI.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API {
    
    struct Grades {
        
        private enum Endpoint {
            static let termGrades = "resources/portal/grades"
            static let termGradeDetails = termGrades + "/detail"
        }
        
        static func getTermGrades(locale: Locale? = nil, completion: @escaping (Result<[GradeTerm], Error>) -> Void) {
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(APIError.invalidLocale))
                return
            }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.termGrades))
            // TODO: customize this (caching mechanism for cookies and responses)
            // TODO: have a loading view for courses
            // TODO: show an network error message if no data is able to be retrieved
            // TODO: create a shared session
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    struct Response: Codable {
                        // TODO: use custom term here
                        let gradeTerms: [GradeTerm]
                        
                        enum CodingKeys: String, CodingKey {
                            case gradeTerms = "terms"
                        }
                   }
                    do {
                        let decoder = JSONDecoder()
                        let responseBody = try decoder.decode([Response].self, from: data)
                        // TODO: check if the following is getting only the first term
                        !responseBody.isEmpty ? completion(.success(responseBody[0].gradeTerms)) : completion(.failure(APIError.invalidData))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.success([]))
                }
            }.resume()
        }
        
        static func getGradeDetails(for assignmentID: Int, locale: Locale? = nil, completion: @escaping (Result<([Term],[GradeDetail]), Error>) -> ()) {
            
            guard let locale = locale ?? PersistentLocale.getLocale() else {
                completion(.failure(APIError.invalidLocale))
                return
            }
            let urlRequest = URLRequest(url: locale.districtBaseURL.appendingPathComponent(Endpoint.termGradeDetails + "/\(assignmentID)"))
            
            API.defaultURLSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                else if let data = data {
                    struct Response: Codable {
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
                        API.resolveCategories(for: &response.gradeDetails)
                        API.resolveTerms(for: &response.gradeDetails)
                        completion(.success((response.terms, response.gradeDetails)))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
                else {
                    completion(.failure(APIError.invalidData))
                }
            }.resume()
            
        }
        
    }
    
    private static func resolveTerms(for gradeDetails: inout [GradeDetail]) {
        gradeDetails.removeAll { gradeDetail in
            return !gradeDetail.grade.isIndividualGrade && !gradeDetail.grade.hasCompositeTasks
        }
        var termsWithAssignments = [String: [GradingCategory]]()
        gradeDetails.forEach { gradeDetail in
            if gradeDetail.grade.isIndividualGrade {
                termsWithAssignments[gradeDetail.grade.termName] = gradeDetail.categories
            }
        }
        for index in gradeDetails.indices {
            if !gradeDetails[index].grade.isIndividualGrade && gradeDetails[index].grade.hasCompositeTasks {
                var allTerms = Set<String>()
                gradeDetails[index].linkedGrades?.forEach { grade in
                    allTerms.insert(grade.termName)
                    if let cumulativeTermName = grade.cumulativeTermName {
                        allTerms.insert(cumulativeTermName)
                    }
                }
                allTerms.forEach { term in
                    if let gradingCategories = termsWithAssignments[term] {
                        gradingCategories.forEach { gradingCategory in
                            if gradeDetails[index].categories.contains(where: {$0.id == gradingCategory.id}) {
                                if let categoryIndex = gradeDetails[index].categories.firstIndex(where: {$0.id == gradingCategory.id}) {
                                    gradeDetails[index].categories[categoryIndex].assignments += gradingCategory.assignments
                                }
                            }
                            else {
                                gradeDetails[index].categories.append(gradingCategory)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private static func resolveCategories(for gradeDetails: inout [GradeDetail]) {
        for (detailIndex, detail) in gradeDetails.enumerated() {
            for (categoryIndex, category) in detail.categories.enumerated() {
                for assignmentIndex in category.assignments.indices {
                    gradeDetails[detailIndex]
                        .categories[categoryIndex]
                        .assignments[assignmentIndex].categoryName = category.name
                    gradeDetails[detailIndex]
                        .categories[categoryIndex]
                        .assignments[assignmentIndex].categoryID = category.id
                }
            }
        }
    }
}
