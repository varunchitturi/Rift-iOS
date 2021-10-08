//
//  CourseDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI

class CourseDetailViewModel: ObservableObject {

    @Published private var courseDetailModel: CourseDetailModel
    
    var assignments: [Assignment] {
        var assignments: [Assignment] = []
        courseDetailModel.gradeDetail?.categories.forEach { category in
            assignments += category.assignments
        
        }
        assignments.sort { lhs, rhs in
            if let lhs = lhs.dueDate, let rhs = rhs.dueDate {
                return lhs > rhs
            }
            return lhs.dueDate != nil ? false : true
        }
        return assignments
    }
    
    var courseName: String {
        courseDetailModel.course.courseName
    }
    
    var gradeDetail: GradeDetail? {
        courseDetailModel.gradeDetail
    }
    
    var courseGradeDisplay: String {
        courseDetailModel.course.gradeDisplay
    }
    
    init(course: Course) {
        self.courseDetailModel = CourseDetailModel(course: course)
        API.Grades.getGradeDetails(for: course.sectionID) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(( _ , let gradeDetails)):
                    if !gradeDetails.isEmpty {
                        self?.courseDetailModel.gradeDetail = gradeDetails[0]
                    }
                    else {
                        print("no grade details found")
                    }
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
        
    }
  
}
