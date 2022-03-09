//
//  CategoryGrade.swift
//  Rift
//
//  Created by Varun Chitturi on 11/21/21.
//

import Foundation



/// A grade for a `GradingCategory` given by Infinite Campus
struct CategoryGrade: Decodable, Equatable {
    
    /// The letter grade for the `GradingCategory`
    let letterGrade: String?
    
    /// The total points earned in the `GradingCategory`
    var currentPoints: Double?
    
    /// The total points in the `GradingCategory`
    var totalPoints: Double?
    
    /// The final grade percentage for the `GradingCategory`
    var percentage: Double?
    
    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
        case percentage = "progressPercent"
    }
    
}





