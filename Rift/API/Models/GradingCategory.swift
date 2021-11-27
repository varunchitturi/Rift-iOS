//
//  GradingCategory.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

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
    
    let id: Int
    let name: String
    let isWeighted: Bool
    let weight: Double
    let isExcluded: Bool
    var isCalculated = false
    var assignments: [Assignment]
    let usePercent: Bool
    private(set) var categoryGrade: CategoryGrade?
    
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
