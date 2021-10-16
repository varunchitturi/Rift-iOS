//
//  Grade.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation



struct Grade: Codable, Equatable {
    let letterGrade: String?
    let percentage: Double?
    let currentPoints: Double?
    let totalPoints: Double?
    let termName: String
    let termType: String?
    let groupWeighted: Bool
    

    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case percentage = "progressPercent"
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
        case termName
        case termType = "taskName"
        case groupWeighted
    }
    
}




