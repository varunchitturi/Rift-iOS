//
//  GradeDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct GradeDetail: Codable {
    
    let grade: Grade
    var categories: [GradingCategory]
    
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
    }
}
