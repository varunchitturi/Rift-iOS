//
//  Grade.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation



struct Grade: Codable {
    let letterGrade: String?
    let percentage: Double?
    let currentPoints: Double?
    let totalPoints: Double?
    let termName: String
    let termType: String?
    
    var percentageString: String {
        guard let percentage = percentage?.description else {
            if let totalPoints = totalPoints, let currentPoints = currentPoints {
                return (((currentPoints / totalPoints) * 100).rounded() * 100).description.appending("%")
            } else {
                return "-"
            }
        }
        return percentage.appending("%")
    }
    
    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case percentage = "progressPercent"
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
        case termName
        case termType = "taskName"
    }
    
}



