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
    @Binding var assignmentToEdit: Assignment
    var assignmentIsDeleted = false
    
    
    // TODO: remove all extensions and make them computed vars in view model
    
    private var originalAssignment: Assignment? {
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
        assignmentToEdit.assignmentName
    }
    
    var assignedDateDisplay: String {
        if let assignedDate = originalAssignment?.assignedDate {
            let formatter = DateFormatter.simpleDate
            return formatter.string(from: assignedDate)
        }
        return Text.nilStringText
        
    }
    var dueDateDisplay: String {
        if let dueDate = originalAssignment?.assignedDate {
            let formatter = DateFormatter.simpleDate
            return formatter.string(from: dueDate)
        }
        return Text.nilStringText
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
    
    
    struct StatsDisplay {
        let header: String
        let text: String
    }
    
    var statsDisplays: [StatsDisplay] {
        return [
            // TODO: have anything to do with displays such as percentage display functions in view models
            StatsDisplay(header: "Due", text: dueDateDisplay),
            StatsDisplay(header: "Assigned", text: assignedDateDisplay),
            StatsDisplay(header: "Real", text: percentageDisplay(for: originalAssignment ?? assignmentToEdit)),
            StatsDisplay(header: "Calculated", text: percentageDisplay(for: modifiedAssignment)),
        ]
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
        print("init")
        self.assignmentDetailModel = AssignmentDetailModel(originalAssignment: originalAssignment, modifiedAssignment: assignmentToEdit.wrappedValue, gradingCategories: gradingCategories)
        self._assignmentToEdit = assignmentToEdit
        categorySelectionIndex = gradingCategories.firstIndex(where: {$0.id == assignmentToEdit.wrappedValue.categoryID})
        provisionInput(with: self.assignmentToEdit)
    }
    
    // TODO: organize structure of files
    
    private func percentageDisplay(for assignment: Assignment) -> String {
        if let totalPoints = assignment.totalPoints, let scorePoints = assignment.scorePoints {
            return ((scorePoints/totalPoints) * 100).truncated(2).description.appending("%")
        }
        return Text.nilStringText
    }
    
    
    private func provisionInput(with assignment: Assignment) {
        totalPointsText = assignment.totalPoints?.description ?? ""
        scorePointsText = assignment.scorePoints != nil ? assignment.scorePoints!.description :  ""
        categorySelectionIndex = gradingCategories.firstIndex(where: {$0.id == assignment.categoryID})
    }
    
    
    // MARK: - Intents
    
    func getDetail() {
        if let originalAssignment = originalAssignment {
            API.Assignments.getAssignmentDetail(for: originalAssignment) { [weak self] result in
                switch result {
                case .success(let detail):
                    self?.assignmentDetailModel.assignmentDetail = detail
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
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
