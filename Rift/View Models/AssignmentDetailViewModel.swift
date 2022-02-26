//
//  AssignmentDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import Foundation
import OrderedCollections
import SwiftUI

/// MVVM view model for the `AssignmentDetailView`
class AssignmentDetailViewModel: ObservableObject {
    
    /// MVVM model
    @Published private var assignmentDetailModel: AssignmentDetailModel
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .loading
    
    /// The `Assignment` that is being viewed
    /// - This is the `Assignment` that was previously shown in the `CourseDetailView`
    /// - Changes that the user makes to `modifiedAssignment` will be applied to this `Assignment` when the `AssignmentDetailView` disappears
    @Binding var assignmentToEdit: Assignment
    
    /// Gives if the user wanted to delete the `Assignment` and remove it from grade calculation
    var assignmentIsDeleted = false
    
    
    // TODO: remove all extensions and make them computed vars in view model
    
    /// The original, unedited `Assignment` from Infinite Campus if available
    /// - This property is `nil` if the user created the `Assignment` themselves
    /// - Note: The user should not be able to edit this `Assignment`
    var originalAssignment: Assignment? {
        assignmentDetailModel.originalAssignment
    }
    /// A temporary `Assignment` created for the user to edit
    /// - This is the assignment that is currently being edited in the `AssignmentDetailView`
    /// - Once the `AssignmentDetailView` disappears, changes to this `Assignment` will be applied to `assignmentToEdit`
    var modifiedAssignment: Assignment {
        get {
            assignmentDetailModel.modifiedAssignment
        }
        set {
            assignmentDetailModel.modifiedAssignment = newValue
        }
    }
    
    /// Gives whether the user has edited the `Assignment`
    var hasModifications: Bool {
        (originalAssignment ?? assignmentToEdit) != modifiedAssignment
    }
    
    /// The name of the assignment being edited
    var assignmentName: String {
        assignmentToEdit.name
    }
    
    /// Any available remarks on the assignment posted by the instructor on Infinite Campus
    var remarks: OrderedDictionary<String, String?> {
        let assignmentDetail = assignmentDetailModel.assignmentDetail
        let remarks: OrderedDictionary<String, String?> =  [
            "Summary": assignmentDetail?.description.summary,
            "Comments": originalAssignment?.comments,
        ]
        
        return remarks
    }
    
    
    /// The grading categories that this assignment can be a part of
    var gradingCategories: [GradingCategory] {
        assignmentDetailModel.gradingCategories
    }
    
    /// The text value for the total points field in the `AddAssignmentView`
    var totalPointsText: String = "" {
        willSet {
            modifiedAssignment.totalPoints = Double(newValue)
        }
    }
    
    /// The text value for the score points field in the `AddAssignmentView`
    var scorePointsText: String = "" {
        willSet {
            modifiedAssignment.scorePoints = Double(newValue)
        }
    }
    
    /// The index in the `assignmentDetailModel.gradingCategories` array of the selected category for the new assignment
    var categorySelectionIndex: Int? {
        didSet {
            // TODO: add assignment.category which is a computed var with a getter and setter. This is done over setting categoryName and ID individually.
            if let categorySelectionIndex = categorySelectionIndex {
                modifiedAssignment.categoryName = gradingCategories[categorySelectionIndex].name
                modifiedAssignment.categoryID = gradingCategories[categorySelectionIndex].id
            }
            
        }
    }

    init(originalAssignment: Assignment?, assignmentToEdit: Binding<Assignment>, gradingCategories: [GradingCategory]) {
        self.assignmentDetailModel = AssignmentDetailModel(originalAssignment: originalAssignment, modifiedAssignment: assignmentToEdit.wrappedValue, gradingCategories: gradingCategories)
        self._assignmentToEdit = assignmentToEdit
        categorySelectionIndex = gradingCategories.firstIndex(where: {$0.id == assignmentToEdit.wrappedValue.categoryID})
        provisionInput(with: self.assignmentToEdit)
    }
    
    // TODO: organize structure of files
    
    /// Sets all the input to their default values
    /// - Parameter assignment: The assignment to use to set default values
    private func provisionInput(with assignment: Assignment) {
        totalPointsText = assignment.totalPoints?.description ?? ""
        scorePointsText = assignment.scorePoints != nil ? assignment.scorePoints!.description :  ""
        categorySelectionIndex = gradingCategories.firstIndex(where: {$0.id == assignment.categoryID})
    }
    
    
    // MARK: - Intents
    
    /// Gets the `AssignmentDetail` for the `originalAssignment` if available
    func fetchAssignmentDetail() {
        if let originalAssignment = originalAssignment {
            networkState = .loading
            API.Assignments.getAssignmentDetail(for: originalAssignment) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detail):
                        self?.assignmentDetailModel.assignmentDetail = detail
                        self?.networkState = .success
                    case .failure(let error):
                        self?.networkState = .failure(error)
                        print(error)
                    }
                }
            }
        }
        else {
            networkState = .success
        }
    }
    
    /// Commits the changes in `modifiedAssignment` to `assignmentToEdit`
    /// - Commits the changes made by the user so they are reflected in the `CourseDetailView`
    func commitChanges() {
        assignmentToEdit = modifiedAssignment
    }
    
    // TODO: stop using totalPointsText and scorePointsText. Source of truth for text field should be from the assignment itself, not a seperate binding. Create a capsuleNumberfield component to accomplish this. Make sure to abide by DRY principles.
    /// Resets any changes made by the user
    func resetChanges() {
        let initialAssignment = originalAssignment ?? assignmentToEdit
        modifiedAssignment = initialAssignment
        provisionInput(with: initialAssignment)
    }
    
}
