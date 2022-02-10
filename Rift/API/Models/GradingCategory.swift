//
//  GradingCategory.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

/// A category used in calculating the final grade in a term
/// - A `GradingCategory` contains the grade, assignments, and other metadata for a category
struct GradingCategory: Identifiable, Decodable, Equatable {
    
    init(id: Int, name: String, isWeighted: Bool, weight: Double, isExcluded: Bool, isCalculated: Bool = false, assignments: [Assignment], usePercent: Bool, categoryGrade: CategoryGrade? = nil) {
        self.id = id
        self.name = name
        self.isWeighted = isWeighted
        self.weight = weight
        self.isExcluded = isExcluded
        self.isCalculated = isCalculated
        self.assignments = assignments
        self.usePercent = usePercent
        self.categoryGrade = categoryGrade
    }
    
    /// An Infinite Campus generated `ID` for a category
    /// - Equivalent to `groupID` in the official Infinite Campus API
    let id: Int
    
    /// The name of the category
    let name: String
    
    /// Gives whether this category is weighted in terms of grade calculation
    /// - If `false`, then this category doesn't use weight-style grade calculation
    /// - If a term, doesn't use weight-style grade calculation, then all of it categories will have `isWeighted` set to `false`
    let isWeighted: Bool
    
     /// If the term uses a weighted grading style, then the `weight` is how much this category is weighted
     /// - The weight is given as a whole number.
     /// - Note: If `isWeighted` is false, this value will be 0
    let weight: Double
    
    /// Gives whether this category should be excluded when calculating the grade for a term
    let isExcluded: Bool
    
    /// Gives whether the current points should be calculated manually using the grades for each assignment in `assignments` or whether the default value from Infinite Campus is used
    /// - If `false` the default value from Infinite Campus will be used
    /// - If `true` the `currentPoints`, `totalPoints`, and `percentage` will be calculated manually by iterating over all the assignments
    /// - Note: `currentPoints`, `totalPoints`, and `percentage` are computed values and are reactive to changes to `assignments` when this is `true`
    ///
    /// \
    ///   The default value of `isCalculated` is `false`
    var isCalculated = false
    
    /// The assignments that are in this category
    var assignments: [Assignment]
    
    /// Gives whether the percentage or points of assignments  should be used in grade calculation
    /// - If `true`, then the number of points for assignments won't be considered. Only the ratio between scored points over total points (percentage) will be sued to calculated the grade. For example. an assignment that is scored as 1/2 has the same affect on your grade as an assignment that is scored as 50/100.
    /// - If `false`, then the number of points for assignment will be considered. For example, an assignment that is scored as 1/2 will affect your grade less than an assignment that is scored as 50/100.
    let usePercent: Bool
    
    /// The grade for this category provided by Infinite Campus
    /// - If `isCalculated` is `true`, then the values in `categoryGrade` will be disregarded and the grades will be calculated manually from `assignments`
    /// - If `isCalculated` is `false`, then the values in `categoryGrade` will be used
    private(set) var categoryGrade: CategoryGrade?
    
    /// The total points earned from all assignments in this category
    /// - Note: Calculation of this value is affected by `isCalculated`
    var currentPoints: Double? {
        if isCalculated {
            var currentPoints: Double?
            assignments.forEach { `assignment` in
                if let assignmentScorePoints = `assignment`.scorePoints, let assignmentTotalPoints = `assignment`.totalPoints {
                    let assignmentScore = usePercent ? (assignmentScorePoints/assignmentTotalPoints) * 100 : assignmentScorePoints
                    currentPoints = (currentPoints ?? 0) + assignmentScore
                }
            }
            return currentPoints
        }
        return categoryGrade?.currentPoints
    }
    
    /// The total points from all assignments in this category
    /// - Note: Calculation of this value is affected by `isCalculated`
    var totalPoints: Double? {
        if isCalculated {
            var totalPoints: Double?
            assignments.forEach { `assignment` in
                if `assignment`.scorePoints != nil, let assignmentTotalPoints = `assignment`.totalPoints {
                    let assignmentTotal = usePercent ? 100 : assignmentTotalPoints
                    totalPoints = (totalPoints ?? 0) + assignmentTotal
                }
            }
            return totalPoints
        }
        return categoryGrade?.totalPoints
    }
    
    /// The final grade percentage of this category
    /// - Note: Calculation of this value is affected by `isCalculated`
    var percentage: Double? {
        if isCalculated {
            guard let currentPoints = currentPoints, let totalPoints = totalPoints else {
                return nil
            }
            return ((currentPoints/totalPoints) * 100).truncated(2)
        }
        return categoryGrade?.percentage
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "groupID"
        case name
        case isWeighted, isExcluded
        case assignments
        case categoryGrade = "progress"
        case weight
        case usePercent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let isWeighted = (try? container.decode(Bool?.self, forKey: .isWeighted)) ?? false
        let isExcluded = (try? container.decode(Bool.self, forKey: .isExcluded)) ?? true
        let assignments = (try? container.decode([Assignment]?.self, forKey: .assignments)) ?? []
        let categoryGrade = try? container.decode(CategoryGrade?.self, forKey: .categoryGrade)
        let weight = (try? container.decode(Double?.self, forKey: .weight)) ?? 0
        let usePercent = (try? container.decode(Bool?.self, forKey: .usePercent)) ?? false
        
        self.init(id: id, name: name, isWeighted: isWeighted, weight: weight, isExcluded: isExcluded, assignments: assignments, usePercent: usePercent, categoryGrade: categoryGrade)
    }
    
}
