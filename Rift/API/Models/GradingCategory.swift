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
    var assignments: [Assignment]
    
    // TODO: change computed properties to stored properties with a will set to improve performance
    
    var totalPoints: Double? {
        var totalPoints = 0.0
        for assignment in assignments {
            if assignment.scorePoints != nil && assignment.isActive {
                totalPoints += assignment.totalPoints ?? 0
            }
        }
        return totalPoints != 0 ? totalPoints : nil
    }
    
    var currentPoints: Double? {
        
        if assignments.allSatisfy ({ $0.scorePoints == nil }){
            return nil
        }
        var currentPoints = 0.0
        for assignment in assignments {
            if assignment.isActive {
                currentPoints += assignment.scorePoints ?? 0
            }
        }
        return currentPoints
    }
    
    var percentage: Double? {
        guard let currentPoints = currentPoints, let totalPoints = totalPoints else {
            return nil
        }
        
        return (currentPoints / totalPoints) * 100

    }
    
    enum CodingKeys: String, CodingKey {
        case id = "groupID"
        case name
        case isWeighted, isExcluded
        case assignments
        case weight
    }
    
}
