//
//  GradingCategory.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct GradingCategory: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let isWeighted: Bool
    let weight: Double
    let isExcluded: Bool
    var assignments: [Assignment] {
        didSet {
            var currentPoints: Double?
            var totalPoints: Double?
            assignments.forEach { `assignment` in
                if let assignmentScorePoints = `assignment`.scorePoints, let assignmentTotalPoints = `assignment`.totalPoints {
                    currentPoints = (currentPoints ?? 0) + assignmentScorePoints
                    totalPoints = (totalPoints ?? 0) + assignmentTotalPoints
                }
            }
            categoryGrade?.currentPoints = currentPoints
            categoryGrade?.totalPoints = totalPoints
        }
    }
    private(set) var categoryGrade: CategoryGrade?
    
    var totalPoints: Double? {
        categoryGrade?.totalPoints
    }
    
    var currentPoints: Double? {
        categoryGrade?.currentPoints
    }
    
    var percentage: Double? {
        guard let currentPoints = currentPoints, let totalPoints = totalPoints else {
            return nil
        }
        return ((currentPoints/totalPoints) * 100).rounded(2)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "groupID"
        case name
        case isWeighted, isExcluded
        case assignments
        case categoryGrade = "progress"
        case weight
    }
    
}
