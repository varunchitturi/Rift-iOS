//
//  AssignmentDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import Foundation

struct AssignmentDetailModel {
    
    
    init(originalAssignment: Assignment, modifiedAssignment: Assignment, gradingCategories: [GradingCategory], assignmentDetail: AssignmentDetail? = nil) {
        self.gradingCategories = gradingCategories
        self.assignmentDetail = assignmentDetail
        self.originalAssignment = originalAssignment
        self.modifiedAssignment = modifiedAssignment
    }
    
    let gradingCategories: [GradingCategory]
    var assignmentDetail: AssignmentDetail?
    var originalAssignment: Assignment
    var modifiedAssignment: Assignment
}
