//
//  AddAssignmentViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftUI

class AddAssignmentViewModel: ObservableObject {
    @Published var addAssignmentModel: AddAssignmentModel
    @Binding var assignments: [Assignment]
    
    
    
    
    init(courseName: String, assignments: Binding<[Assignment]>, gradingCategories: [GradingCategory]) {
        addAssignmentModel = AddAssignmentModel(courseName: courseName, gradingCategories: gradingCategories)
        self._assignments = assignments
    }
    
    var newAssignment: Assignment {
        get {
            addAssignmentModel.newAssignment
        }
        set {
            addAssignmentModel.newAssignment = newValue
        }
    }
    
    var categoryNames: [String] {
        addAssignmentModel.gradingCategories.map {$0.name}
    }
    
    var totalPointsText: String = "" {
        willSet {
            newAssignment.totalPoints = Double(newValue)
        }
    }
    var scorePointsText: String = "" {
        willSet {
            newAssignment.scorePoints = Double(newValue)
        }
    }
    
    var assignmentName: String {
        get {
            newAssignment.assignmentName
        }
        set {
            newAssignment.assignmentName = newValue
        }
    }
    
    
    var categorySelectionIndex: Int? {
        didSet {
            if let categorySelectionIndex = categorySelectionIndex, addAssignmentModel.gradingCategories.indices.contains(categorySelectionIndex) {
                let gradingCategory = addAssignmentModel.gradingCategories[categorySelectionIndex]
                newAssignment.categoryID = gradingCategory.id
                newAssignment.categoryName = gradingCategory.name
            }
        }
    }
    
    var asignmentName: String {
        get {
            addAssignmentModel.newAssignment.assignmentName
        }
        set {
            addAssignmentModel.newAssignment.assignmentName = newValue
        }
    }
    
    var assignmentIsValid: Bool {
        addAssignmentModel.newAssignment.categoryID != nil &&
        addAssignmentModel.newAssignment.categoryName != nil &&
        addAssignmentModel.newAssignment.assignmentName != ""
    }

    func addAssignment() {
        assignments.append(addAssignmentModel.newAssignment)
    }
  
}
