//
//  GradeDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation
import SwiftUI

struct GradeDetail: Decodable, Equatable, Identifiable {
    
    var grade: Grade
    private(set) var categories: [GradingCategory]
    let linkedGrades: [Grade]?
    let id: UUID = UUID()
    var isCalculated = false {
        willSet {
            for index in categories.indices {
                categories[index].isCalculated = newValue
            }
        }
    }
    
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
        if isCalculated {
            return calculatePercentage()
        }
        return grade.percentage
    }
    
    enum CodingKeys: String, CodingKey {
        case grade = "task"
        case categories
        case linkedGrades = "children"
    }
    
    private func calculatePercentage() -> Double? {
        if categories.allSatisfy ({ $0.percentage == nil }) {
            return nil
        }
        
        let useGroupWeight = categories.allSatisfy {$0.isWeighted == true}
        
        switch useGroupWeight {
            // TODO: Describe all properties for API models
        case true:
            var currentWeight = 0.0
            var totalWeight = 0.0
            categories.forEach { category in
                if let percentage = category.percentage, !category.isExcluded {
                    totalWeight += category.weight
                    currentWeight += category.weight * percentage
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
    
    mutating func resolveCategories() {
        for (categoryIndex, category) in self.categories.enumerated() {
            for assignmentIndex in category.assignments.indices {
                self.categories[categoryIndex].assignments[assignmentIndex].categoryName = category.name
                self.categories[categoryIndex].assignments[assignmentIndex].categoryID = category.id
            }
        }
    }
    
    mutating func addGradingCategory(_ gradingCategory: GradingCategory) {
        self.categories.append(gradingCategory)
    }
}

extension Array where Element == GradeDetail {
    mutating func resolveCategories() {
        for index in self.indices {
            self[index].resolveCategories()
        }
    }
    
    mutating func resolveTerms() {
        
        // Collects all categories by termName and resets all categories for each GradingDetail
        var termsWithAssignments = [String: [GradingCategory]]()
        for detailIndex in self.indices {
            if self[detailIndex].grade.hasInitialAssignments {
                termsWithAssignments[self[detailIndex].grade.termName] = self[detailIndex].categories
                self[detailIndex].assignments = []
            }
        }
        
        // Assigns the correct assignments to all of the GradingDetails
        for index in self.indices {
            
            if self[index].grade.hasCompositeTasks || self[index].grade.hasInitialAssignments {
                
                // Accumalates all the terms for a GradingDetail
                var allTerms = Set<String>()
                allTerms.insert(self[index].grade.termName)
                if let cumulativeTermName = self[index].grade.cumulativeTermName {
                    allTerms.insert(cumulativeTermName)
                }
                
                self[index].linkedGrades?.forEach { grade in
                    allTerms.insert(grade.termName)
                    if let cumulativeTermName = grade.cumulativeTermName {
                        allTerms.insert(cumulativeTermName)
                    }
                }
                
                // Adds the assignments to a GradingDetail based on the terms accumalated
                allTerms.forEach { term in
                    if let gradingCategories = termsWithAssignments[term] {
                        gradingCategories.forEach { gradingCategory in
                            if self[index].categories.contains(where: {$0.id == gradingCategory.id}) {
                                self[index].assignments += gradingCategory.assignments
                            }
                            else {
                                self[index].addGradingCategory(gradingCategory)
                            }
                        }
                    }
                }
            }
        }
    }
    
    mutating func setCalculation(to isCalculated: Bool) {
        for index in self.indices {
            self[index].isCalculated = isCalculated
        }
    }
}
