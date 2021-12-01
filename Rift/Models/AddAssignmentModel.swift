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
                                   assignmentName: "",
                                   dueDate: nil,
                                   assignedDate: nil,
                                   courseName: courseName,
                                   totalPoints: nil,
                                   scorePoints: nil,
                                   comments: nil,
                                   categoryName: nil,
                                   categoryID: nil
        )
        self.gradingCategories = gradingCategories
    }
    
    func validateAssignmentName(_ assignment: String?) throws -> String {
        guard let assignment = assignment else { throw
            ValidationError.invalidValue }
        
        return assignment
    }
    
    

}

enum ValidationError: LocalizedError {
    case invalidValue
    
    var errorDescription: String? {
        switch self {
        case .invalidValue:
            return "Invalid Assignment Name"
        }
    }
}
