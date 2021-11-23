//
//  GradeDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation
import SwiftUI

struct GradeDetail: Codable, Equatable, Identifiable {
    
    let grade: Grade
    var categories: [GradingCategory]
    let linkedGrades: [Grade]?
    let id: UUID = UUID()
    var assignments: [Assignment] {
        get {
            var assignments: [Assignment] = []
            categories.forEach { category in
                assignments += category.assignments
            
            }
            assignments.sort { lhs, rhs in
                if let lhs = lhs.dueDate, let rhs = rhs.dueDate {
                    return lhs > rhs
                }
                return lhs.dueDate != nil ? false : true
            }
            return assignments
        }
        set {
            for categoryIndex in categories.indices {
                var newAssignments = [Assignment]()
                for assignmentIndex in newValue.indices {
                    if let categoryID = newValue[assignmentIndex].categoryID, categoryID == categories[categoryIndex].id {
                        newAssignments.append(newValue[assignmentIndex])
                    }
                }
                categories[categoryIndex].assignments = newAssignments
            }
        }
    }
    
    
    var totalPercentage: Double? {
        
        if categories.allSatisfy ({ $0.percentage == nil }) {
            return nil
        }

        switch grade.groupWeighted {
            // TODO: Describe all properties for API models
        case true:
            var currentWeight = 0.0
            var totalWeight = 0.0
            categories.forEach { category in
                let percentage = category.percentage
                if !category.isExcluded && percentage != nil {
                    totalWeight += category.weight
                    currentWeight += category.weight * percentage!
                }
            }
            return totalWeight != 0 ? currentWeight / totalWeight : nil
        case false:
            var currentPoints = 0.0
            var totalPoints = 0.0
            categories.forEach { category in
                if !category.isExcluded && category.totalPoints != nil {
                    currentPoints += category.currentPoints ?? 0
                    totalPoints += category.totalPoints ?? 0
                }
            }
            return totalPoints != 0 ? (currentPoints / totalPoints) * 100 : nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case grade = "task"
        case categories
        case linkedGrades = "children"
    }
}
