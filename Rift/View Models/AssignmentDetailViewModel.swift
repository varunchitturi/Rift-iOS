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
    @Binding var editingAssignment: Assignment
    
    // TODO: remove all extensions and make them computed vars in view model
    
    private var assignment: Assignment {
        assignmentDetailModel.assignment
    }

    var assignmentName: String {
        return assignmentDetailModel.assignment.assignmentName
    }
    
    var assignedDateDisplay: String {
        if let assignedDate = assignment.assignedDate {
            let formatter = DateFormatter.simpleDate
            return formatter.string(from: assignedDate)
        }
        return Text.nilStringText
        
    }
    var dueDateDisplay: String {
        if let dueDate = assignment.assignedDate {
            let formatter = DateFormatter.simpleDate
            return formatter.string(from: dueDate)
        }
        return Text.nilStringText
    }
    
    var remarks: OrderedDictionary<String, String?> {
        let assignmentDetail = assignmentDetailModel.assignmentDetail
        let remarks: OrderedDictionary<String, String?> =  [
            "Summary": assignmentDetail?.description.summary,
            "Comments": assignment.comments,
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
            StatsDisplay(header: "Real", text: percentageDisplay(for: assignment)),
            StatsDisplay(header: "Calculated", text: percentageDisplay(for: editingAssignment)),
        ]
        
    }
    
    
    var totalPointsText: String {
        willSet {
            editingAssignment.totalPoints = Double(newValue)
        }
    }
    var scorePointsText: String {
        willSet {
            editingAssignment.scorePoints = Double(newValue)
        }
    }

    init(originalAssignment: Assignment, editingAssignment: Binding<Assignment>, gradingCategories: [GradingCategory]) {
        self.assignmentDetailModel = AssignmentDetailModel(assignment: originalAssignment, gradingCategories: gradingCategories)
        self._editingAssignment = editingAssignment
        totalPointsText = originalAssignment.totalPoints != nil ? originalAssignment.totalPoints!.description :  ""
        scorePointsText = originalAssignment.scorePoints != nil ? originalAssignment.scorePoints!.description :  ""
        print("init")
    }
    
    // TODO: organize structure of files
    
    private func percentageDisplay(for assignment: Assignment) -> String {
        if let totalPoints = assignment.totalPoints, let scorePoints = assignment.scorePoints {
            return ((scorePoints/totalPoints) * 100).truncated(2).description.appending("%")
        }
        return Text.nilStringText
    }
    
    // MARK: - Intents
    
    func getDetail() {
        let id = assignment.id
        API.Assignments.getAssignmentDetail(for: id) { [weak self] result in
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
