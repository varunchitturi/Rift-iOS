//
//  GradingCategory.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct GradingCategory: Identifiable, Codable {
    let id: Int
    let name: String
    let isWeighted: Bool
    var assignments: [Assignment]
    
    var totalPoints: Double? {
        var totalPoints = 0.0
        for assignment in assignments {
            totalPoints += assignment.totalPoints ?? 0
        }
        return totalPoints != 0 ? totalPoints : nil
    }
    
    var currentPoints: Double? {
        var currentPoints = 0.0
        for assignment in assignments {
            currentPoints += assignment.scorePoints ?? 0
        }
        return assignments.allSatisfy {$0.scorePoints != nil} ? currentPoints : nil
    }
    
    var percentage: Double? {
        guard let currentPoints = currentPoints, let totalPoints = totalPoints else {
            return nil
        }
        
        return ((currentPoints / totalPoints) * 100).rounded(2)

    }
    
    enum CodingKeys: String, CodingKey {
        case id = "groupID"
        case name
        case isWeighted
        case assignments
    }
    
}
