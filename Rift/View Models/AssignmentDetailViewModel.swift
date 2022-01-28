//
//  AssignmentDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import Foundation
import OrderedCollections
import SwiftUI

class AssignmentDetailViewModel: ObservableObject {
    @Published private var assignmentDetailModel: AssignmentDetailModel
    @Published var networkState: AsyncState = .loading
    @Binding var assignmentToEdit: Assignment
    var assignmentIsDeleted = false
    
    
    // TODO: remove all extensions and make them computed vars in view model
    
    var originalAssignment: Assignment? {
        assignmentDetailModel.originalAssignment
    }
    var modifiedAssignment: Assignment {
        get {
            assignmentDetailModel.modifiedAssignment
        }
        set {
            assignmentDetailModel.modifiedAssignment = newValue
        }
    }

    var hasModifications: Bool {
        (originalAssignment ?? assignmentToEdit) != modifiedAssignment
    }
    
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
            // TODO: add assignment.category which is a computed var with a getter and setter. This is done over settign categoryName and ID individually.
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
            API.Assignments.getAssignmentDetail(for: originalAssignment) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detail):
                        self?.assignmentDetailModel.assignmentDetail = detail
                        self?.networkState = .idle
                    case .failure(let error):
                        self?.networkState = .failure(error)
                        print(error)
                    }
                }
            }
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
