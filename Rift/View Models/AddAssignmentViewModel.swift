//
//  AddAssignmentViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftUI

/// MVVM view model for `AddAssignmentView`
class AddAssignmentViewModel: ObservableObject {
    
    /// MVVM model
    @Published var addAssignmentModel: AddAssignmentModel
    
    /// The list of `Assignment`s that the newly created `Assignment` will be added to
    @Binding private var assignments: [Assignment]
    
    
    
    
    init(courseName: String, assignments: Binding<[Assignment]>, gradingCategories: [GradingCategory]) {
        addAssignmentModel = AddAssignmentModel(courseName: courseName, gradingCategories: gradingCategories)
        self._assignments = assignments
    }
    
    /// The new assignment to be added
    var newAssignment: Assignment {
        get {
            addAssignmentModel.newAssignment
        }
        set {
            addAssignmentModel.newAssignment = newValue
        }
    }
    
    /// The names of the possible `GradingCategory`s for the assignment
    var categoryNames: [String] {
        addAssignmentModel.gradingCategories.map {$0.name}
    }
    
    /// The text value for the total points field in the `AddAssignmentView`
    var totalPointsText: String = "" {
        willSet {
            newAssignment.totalPoints = Double(newValue)
        }
    }
    
    /// The text value for the score points field in the `AddAssignmentView`
    var scorePointsText: String = "" {
        willSet {
            newAssignment.scorePoints = Double(newValue)
        }
    }
    
    /// The name of the new assignment to be added
    var assignmentName: String {
        get {
            newAssignment.name
        }
        set {
            newAssignment.name = newValue
        }
    }
    
    
    /// The index in the `addAssignmentModel.gradingCategories` array of the selected category for the new assignment
    var categorySelectionIndex: Int? {
        didSet {
            if let categorySelectionIndex = categorySelectionIndex, addAssignmentModel.gradingCategories.indices.contains(categorySelectionIndex) {
                let gradingCategory = addAssignmentModel.gradingCategories[categorySelectionIndex]
                newAssignment.categoryID = gradingCategory.id
                newAssignment.categoryName = gradingCategory.name
            }
        }
    }
    
    
    /// Gives if the newly created assignment is ready to be added
    /// - You cannot add a newAssignment that doesn't have a `name`, `categoryID`, and `categoryName`
    var assignmentIsValid: Bool {
        addAssignmentModel.newAssignment.categoryID != nil &&
        addAssignmentModel.newAssignment.categoryName != nil &&
        addAssignmentModel.newAssignment.name != ""
    }
    
    /// Adds the newly created `Assignment` to the given list of `Assignment`s
    func addAssignment() {
        assignments.append(addAssignmentModel.newAssignment)
    }
  
}
