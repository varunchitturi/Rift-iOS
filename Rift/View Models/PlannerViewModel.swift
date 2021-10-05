//
//  PlannerViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation

class PlannerViewModel: ObservableObject {
    // TODO: edit this to support multiple filters
    @Published private var planner = Planner()
    
    var assignmentDateList: [Date?: [Assignment]] {
        var assignmentDateList = [Date?: [Assignment]]()
        for assignment in planner.assignmentList {
            let dueDate = assignment.dueDate
            if !assignmentDateList.keys.contains(dueDate) {
                assignmentDateList[dueDate] = []
            }
            assignmentDateList[dueDate]?.append(assignment)
            
        }
        return assignmentDateList
    }
    
    var dates: [Date?] {
        assignmentDateList.keys.sorted { lhs, rhs in
            if let lhs = lhs, let rhs = rhs {
                return lhs > rhs
            }
            return lhs != nil ? false : true
        }
    }
    
    static let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    
    
    init() {
        guard let locale = planner.locale else { return }
        API.Assignments.getList(locale: locale){[weak self] result in
            switch result {
            case .success(let assignmentList):
                self?.planner.assignmentList = assignmentList
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: do better error handling here
            }
        }
    }
}
