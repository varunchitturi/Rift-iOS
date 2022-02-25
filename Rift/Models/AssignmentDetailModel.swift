//
//  AssignmentDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import Foundation

/// MVVM model to handle the `AssignmentDetailView`
struct AssignmentDetailModel {
    
    var originalAssignment: Assignment?
    var modifiedAssignment: Assignment
    let gradingCategories: [GradingCategory]
    var assignmentDetail: AssignmentDetail?
    
}
