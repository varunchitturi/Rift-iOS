//
//  CategoryGrade.swift
//  Rift
//
//  Created by Varun Chitturi on 11/21/21.
//

import Foundation



struct CategoryGrade: Codable, Equatable {
    let letterGrade: String?
    var currentPoints: Double?
    var totalPoints: Double?

    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
    }
    
}





