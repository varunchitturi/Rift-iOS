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
    
    enum CodingKeys: String, CodingKey {
        case grade = "task"
        case categories
        case linkedGrades = "children"
    }
}

extension Array where Element == GradeDetail {
    mutating func resolveCategories() {
        for (detailIndex, detail) in self.enumerated() {
            for (categoryIndex, category) in detail.categories.enumerated() {
                for assignmentIndex in category.assignments.indices {
                    self[detailIndex]
                        .categories[categoryIndex]
                        .assignments[assignmentIndex].categoryName = category.name
                    self[detailIndex]
                        .categories[categoryIndex]
                        .assignments[assignmentIndex].categoryID = category.id
                }
            }
        }
    }
    
    mutating func resolveTerms() {
        var termsWithAssignments = [String: [GradingCategory]]()
        for detailIndex in self.indices {
            if self[detailIndex].grade.isIndividualGrade {
                termsWithAssignments[self[detailIndex].grade.termName] = self[detailIndex].categories
                self[detailIndex].categories.removeAll()
            }
        }
        for detailIndex in self.indices {
            var allTerms = Set<String>()
            allTerms.insert(self[detailIndex].grade.termName)
            if let cumulativeTermName = self[detailIndex].grade.cumulativeTermName {
                allTerms.insert(cumulativeTermName)
            }
            self[detailIndex].linkedGrades?.forEach { grade in
                allTerms.insert(grade.termName)
                if let cumulativeTermName = grade.cumulativeTermName {
                    allTerms.insert(cumulativeTermName)
                }
            }
            if let linkedGroupWeight = self[detailIndex].linkedGrades?.first?.groupWeighted {
                self[detailIndex].grade.groupWeighted = linkedGroupWeight
            }
            allTerms.forEach { term in
                if let gradingCategories = termsWithAssignments[term] {
                    gradingCategories.forEach { gradingCategory in
                        if self[detailIndex].categories.contains(where: {$0.id == gradingCategory.id}) {
                            if let categoryIndex = self[detailIndex].categories.firstIndex(where: {$0.id == gradingCategory.id}) {
                                self[detailIndex].categories[categoryIndex].assignments += gradingCategory.assignments
                            }
                        }
                        else {
                            self[detailIndex].categories.append(gradingCategory)
                        }
                    }
                }
            }
        }
    }
    
}

