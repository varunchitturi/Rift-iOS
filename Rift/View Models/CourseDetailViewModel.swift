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
    @Published var editingGradeDetail: GradeDetail?
    
    // TODO: add a reset button up top
    // TODO: make this process more effecient
    
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
                    self?.courseDetailModel.gradeDetail = gradeDetails.first
                    self?.editingGradeDetail = gradeDetails.first
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
        
    }
    
    // MARK: - Intents
    
  
}

extension GradingCategory {
    var percentageDisplay: String {
        percentage?.truncated(2).description.appending("%") ?? Text.nilStringText
    }
}

extension GradeDetail {
    var totalPercentageDisplay: String {
        totalPercentage?.truncated(2).description.appending("%") ?? Text.nilStringText
    }
}
