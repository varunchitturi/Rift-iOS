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
    let termSelectionID: Int?
    var terms: [Term]?
    var gradeDetails: [GradeDetail]?
    
}
