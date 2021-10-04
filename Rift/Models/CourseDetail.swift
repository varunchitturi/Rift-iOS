//
//  CourseDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

struct CourseDetail {
    // TODO: handle errors when locale doesnt exist
    
    let course: Course
    let locale = PersistentLocale.getLocale()
    
    func getCourseDetails(completion: @escaping (Result<[CategoryProgress], Error>) -> ()) {
        guard let locale = locale else { return }
        let url = locale.districtBaseURL.appendingPathComponent(String(course.sectionID))
        Courses.sharedURLSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data
        }
    }
    private struct CourseDetailResponse {
        let details:
    }
    private struct GradeDetail {
        let gradeDetai
    }
    struct CategoryProgress: Codable {
        let name: String
        let assignments: [Assignment]?
    }
    
}
