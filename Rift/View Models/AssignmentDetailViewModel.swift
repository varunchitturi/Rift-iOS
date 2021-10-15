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
    
    // TODO: remove all extensions and make them computed vars in view model
    var percentageDisplay: String {
        let assignment = assignmentDetailModel.assignment
        if let totalPoints = assignment.totalPoints, let scorePoints = assignment.scorePoints {
            return ((scorePoints/totalPoints) * 100).truncated(2).description.appending("%")
        }
        return Text.nilStringText
    }
    var assignedDateDisplay: String {
        let assignment = assignmentDetailModel.assignment
        if let assignedDate = assignment.assignedDate {
            let formatter = DateFormatter.simpleDate
            return formatter.string(from: assignedDate)
        }
        return Text.nilStringText
        
    }
    var dueDateDisplay: String {
        let assignment = assignmentDetailModel.assignment
        if let dueDate = assignment.assignedDate {
            let formatter = DateFormatter.simpleDate
            return formatter.string(from: dueDate)
        }
        return Text.nilStringText
    }
    
    var remarks: OrderedDictionary<String, String?> {
        let assignment = assignmentDetailModel.assignment
        let assignmentDetail = assignmentDetailModel.assignmentDetail
        let remarks: OrderedDictionary<String, String?> =  [
            "Summary": assignmentDetail?.description.summary,
            "Comments": assignment.comments,
        ]
        
        return remarks
    }
    
    var assignmentName: String {
        assignmentDetailModel.assignment.assignmentName
    }
    
    var gradingCategories: [GradingCategory] {
        assignmentDetailModel.gradingCategories
    }
    
    struct StatsDisplay {
        let header: String
        let stat: String
    }
    
    var statsDisplays: [StatsDisplay] {
        return [
            StatsDisplay(header: "Due", stat: dueDateDisplay),
            StatsDisplay(header: "Assigned", stat: assignedDateDisplay),
            StatsDisplay(header: "Real", stat: percentageDisplay),
            StatsDisplay(header: "Calculated", stat: percentageDisplay),
        ]
        
    }

    init(assignment: Assignment, gradingCategories: [GradingCategory]) {
        self.assignmentDetailModel = AssignmentDetailModel(assignment: assignment, gradingCategories: gradingCategories)
    }
    
    // MARK: - Intents
    
    func getDetail() {
        let id = assignmentDetailModel.assignment.id
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
