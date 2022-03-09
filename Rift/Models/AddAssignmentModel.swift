//
//  AddAssignmentModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

/// MVVM model to handle the `AddAssignmentView`
struct AddAssignmentModel {
    
    /// The new that will be added
    var newAssignment: Assignment
    
    /// The possible `GradingCategories` that can be chosen for this assignment
    var gradingCategories: [GradingCategory]
    
    init(courseName: String, gradingCategories: [GradingCategory]) {
        newAssignment = Assignment(id: UUID().hashValue,
                                   isActive: true,
                                   name: "Assignment",
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
