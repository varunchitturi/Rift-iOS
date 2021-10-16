//
//  AssignmentDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import Foundation

struct AssignmentDetailModel {
    
    init(assignment: Assignment, gradingCategories: [GradingCategory], assignmentDetail: AssignmentDetail? = nil) {
        self.gradingCategories = gradingCategories
        self.assignmentDetail = assignmentDetail
        self.assignment = assignment
    }
    
    let gradingCategories: [GradingCategory]
    var assignmentDetail: AssignmentDetail?
    var assignment: Assignment

}
