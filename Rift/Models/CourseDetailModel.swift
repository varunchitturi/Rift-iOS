//
//  CourseDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

/// MVVM model to handle the `CourseDetailView`
struct CourseDetailModel {
    
    /// The selected course to get detail of
    let course: Course
    
    /// The `id` of the term that the course is part of
    let termSelectionID: Int?
    
    /// List of `Term`s that the course is part of
    var terms: [Term]?
    
    /// List of `GradeDetail`s for the course
    var gradeDetails: [GradeDetail]?
    
}
