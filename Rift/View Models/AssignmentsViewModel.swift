//
//  AssignmentsViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation
import SwiftUI

/// MVVM view model for the `AssignmentsView`
class AssignmentsViewModel: ObservableObject {
    // TODO: edit this to support multiple filters
    
    /// MVVM model
    @Published private var assignmentsModel = AssignmentsModel()
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .idle
    
    /// A dictionary where each key is a `Date` and each value is a list of assignments that are due on that date
    /// - A key of `nil` is for assignments that don't have a due date
    var assignmentDateList: [Date?: [Assignment]] {
        var assignmentDateList = [Date?: [Assignment]]()
        for `assignment` in assignmentsModel.assignmentList {
            let dueDate = `assignment`.dueDate
            if !assignmentDateList.keys.contains(dueDate) {
                assignmentDateList[dueDate] = []
            }
            assignmentDateList[dueDate]?.append(`assignment`)
            
        }
        return assignmentDateList
    }
    
    /// A sorted list of all the dates that assignments are due on
    var dates: [Date?] {
        assignmentDateList.keys.sorted { lhs, rhs in
            if let lhs = lhs, let rhs = rhs {
                return lhs > rhs
            }
            return lhs != nil ? false : true
        }
    }
        
    init() {
        fetchAssignments()
    }
    
    /// Fetches assignments from the API
    func fetchAssignments() {
        networkState = .loading
        API.Assignments.getList {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let assignmentList):
                    self?.assignmentsModel.assignmentList = assignmentList
                    self?.networkState = .success
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.networkState = .failure(error)
                }
            }
        }
    }
}
