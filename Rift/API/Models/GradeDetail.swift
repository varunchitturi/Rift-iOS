//
//  GradeDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation
import SwiftUI

/// A `GradeDetail` is the detailed grade breakdown for a term
struct GradeDetail: Decodable, Equatable, Identifiable {
    // TODO: fix the huge calculations done for this
    
    /// A grade that gives information about the term and it's overall grade
    /// - This data comes straight from Infinite Campus and isn't reactive to changes
    /// - Only use this if you want the the grade that shows on Infinite Campus
    var grade: Grade
    
    /// The categories that make up the overall grade for the term
    private(set) var categories: [GradingCategory]
    
    /// A list of terms that the current term accumulates over
    /// - If the the current term isn't calculated based on other terms, then this value is `nil`
    let linkedGrades: [Grade]?
    
    /// The `id` given to this `GradeDetail`
    let id: UUID = UUID()
    
    /// Gives whether the overall grade for the term should be calculated based on `assignments` or should use the one from Infinite Campus
    var isCalculated = false {
        willSet {
            for index in categories.indices {
                categories[index].isCalculated = newValue
            }
        }
    }
    
    /// An array of `assignment`s consisting of all the assignments in all `categories`
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
    
    /// The overall grade percentage for this term
    /// - Calculation is dependent on `isCalculated`
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
    
    /// Calculates the total percentage based on the all the collective `assignment`s in `categories`
    /// - Returns: The calculated total grade percentage for the term
    private func calculatePercentage() -> Double? {
        if categories.allSatisfy ({ $0.percentage == nil }) {
            return nil
        }
        
        let useGroupWeight = categories.allSatisfy {$0.isWeighted == true}
        
        switch useGroupWeight {
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
    
    /// Adds category information to all assignments
    /// - Adds the category `name` and `id` for all assignments to which they belong to
    mutating func resolveCategories() {
        for (categoryIndex, category) in self.categories.enumerated() {
            for assignmentIndex in category.assignments.indices {
                self.categories[categoryIndex].assignments[assignmentIndex].categoryName = category.name
                self.categories[categoryIndex].assignments[assignmentIndex].categoryID = category.id
            }
        }
    }
    
    /// Adds a `GradingCategory` to a list a `GradeDetail`
    /// The `GradingCategory` gets inserted into the `GradeDetail`'s `categories` property
    /// - Parameter gradingCategory: <#gradingCategory description#>
    mutating func addGradingCategory(_ gradingCategory: GradingCategory) {
        self.categories.append(gradingCategory)
    }
}

extension Array where Element == GradeDetail {
    /// Calls `GradeDetail.resolveCategories()` for each `GradeDetail`
    mutating func resolveCategories() {
        for index in self.indices {
            self[index].resolveCategories()
        }
    }
    
    /// Resolves terms that have linked grades
    /// - When terms grades are calculated as an accumulation of other terms, we need make sure that they contain all the necessary information to manually calculate their grade. Calling `resolveTerms` on an array of `GradeDetail`s makes sure that every `GradeDetail` contains its own assignments as well as assignments from linked grades.
    /// - Complexity: O(k\*n^2), where `n` is the number of `GradeDetail`s in the array and `k` is the max number of assignments that a `GradeDetail` originally has.
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
                
                // Accumulates all the terms for a GradingDetail
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
                
                // Adds the assignments to a GradingDetail based on the terms accumulated
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
    
    /// Sets the calculation method for an array of `GradeDetail`s
    /// - For every `GradeDetail` in an array, it sets their `isCalculated` value to the `isCalculated` function parameter
    /// - Parameter isCalculated: The calculation method to set for all `GradeDetail`s
    mutating func setCalculation(to isCalculated: Bool) {
        for index in self.indices {
            self[index].isCalculated = isCalculated
        }
    }
}
