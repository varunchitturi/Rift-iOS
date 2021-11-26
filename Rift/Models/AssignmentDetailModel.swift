//
//  AssignmentDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import Foundation

struct AssignmentDetailModel {
    
    var originalAssignment: Assignment?
    var modifiedAssignment: Assignment
    let gradingCategories: [GradingCategory]
    var assignmentDetail: AssignmentDetail?
    
}
