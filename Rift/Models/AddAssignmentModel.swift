//
//  AddAssignmentModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

struct AddAssignmentModel {
    
    var newAssignment: Assignment
    
    var gradingCategories: [GradingCategory]
    
    init(courseName: String, gradingCategories: [GradingCategory]) {
        newAssignment = Assignment(id: UUID().hashValue,
                                   isActive: true,
                                   name: "",
                                   dueDate: Date.now,
                                   assignedDate: Date.now,
                                   courseName: courseName,
                                   totalPoints: nil,
                                   scorePoints: nil,
                                   comments: nil,
                                   categoryName: nil,
                                   categoryID: nil
        )
        self.gradingCategories = gradingCategories
    }
    
    

}
