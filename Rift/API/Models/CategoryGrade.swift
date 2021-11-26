//
//  CategoryGrade.swift
//  Rift
//
//  Created by Varun Chitturi on 11/21/21.
//

import Foundation



struct CategoryGrade: Decodable, Equatable {
    let letterGrade: String?
    var currentPoints: Double?
    var totalPoints: Double?
    var percentage: Double?
    
    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
        case percentage = "progressPercent"
    }
    
}





