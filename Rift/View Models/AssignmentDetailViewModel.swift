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
    
    /// The name of 
    var assignmentName: String {
        assignmentToEdit.name
    }

    var remarks: OrderedDictionary<String, String?> {
        let assignmentDetail = assignmentDetailModel.assignmentDetail
        let remarks: OrderedDictionary<String, String?> =  [
            "Summary": assignmentDetail?.description.summary,
            "Comments": originalAssignment?.comments,
        ]
        
        return remarks
    }
    
    
    var gradingCategories: [GradingCategory] {
        assignmentDetailModel.gradingCategories
    }
    
    var totalPointsText: String = "" {
        willSet {
            modifiedAssignment.totalPoints = Double(newValue)
        }
    }
    var scorePointsText: String = "" {
        willSet {
            modifiedAssignment.scorePoints = Double(newValue)
        }
    }
    
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
    
    private func provisionInput(with assignment: Assignment) {
        totalPointsText = assignment.totalPoints?.description ?? ""
        scorePointsText = assignment.scorePoints != nil ? assignment.scorePoints!.description :  ""
        categorySelectionIndex = gradingCategories.firstIndex(where: {$0.id == assignment.categoryID})
    }
    
    
    // MARK: - Intents
    
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
    
    func commitChanges() {
        assignmentToEdit = modifiedAssignment
    }
    // TODO: stop useing totalPointsText and scorePointsText. Source of truth for text field should be from the assignment itself, not a seperate binding. Create a capsuleNumberfield component to accomplish this. Make sure to abide by DRY principles.
    func resetChanges() {
        let initialAssignment = originalAssignment ?? assignmentToEdit
        modifiedAssignment = initialAssignment
        provisionInput(with: initialAssignment)
    }
    
}
