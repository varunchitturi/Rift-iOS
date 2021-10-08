//
//  CourseDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

struct CourseDetailModel {
    // TODO: handle errors when locale doesnt exist
    
    let course: Course
    
    var gradeDetail: GradeDetail?
    
    
}

extension GradingCategory {
    var percentageDisplay: String {
        percentage?.description.appending("%") ?? "-"
    }
}
