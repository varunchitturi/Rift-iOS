//
//  AssignmentsModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation

struct AssignmentsModel {
    
    var assignmentList = [Assignment]()
    
}

extension Assignment {
    var totalPointsDisplay: String {
        self.totalPoints?.description ?? "-"
    }
}
