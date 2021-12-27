//
//  Grade.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation



struct Grade: Decodable, Equatable {
    
    var letterGrade: String?
    let percentage: Double?
    let currentPoints: Double?
    let totalPoints: Double?
    let termName: String
    let termType: String
    let termID: Int
    let hasInitialAssignments: Bool
    let hasCompositeTasks: Bool
    let cumulativeTermName: String?

    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case score
        case percentage = "progressPercent"
        case displayedPercent = "percent"
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
        case termName
        case termType = "taskName"
        case termID
        case hasInitialAssignments = "hasAssignments"
        case hasCompositeTasks
        case cumulativeTermName
        
        
    }
}

extension Grade {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let letterGrade = (try? container.decode(String?.self, forKey: .score)) ??
                        (try? container.decode(String?.self, forKey: .letterGrade))
    
        let percentage = (try? container.decode(Double?.self, forKey: .displayedPercent)) ??
                        (try? container.decode(Double?.self, forKey: .percentage))
        
        let currentPoints = try? container.decode(Double?.self, forKey: .currentPoints)
        let totalPoints = try? container.decode(Double?.self, forKey: .totalPoints)
        let termName = try container.decode(String.self, forKey: .termName)
        let termType = try container.decode(String.self, forKey: .termType)
        let termID = try container.decode(Int.self, forKey: .termID)
        let hasInitialAssignments = try container.decode(Bool.self, forKey: .hasInitialAssignments)
        let hasCompositeTasks = try container.decode(Bool.self, forKey: .hasCompositeTasks)
        let cumulativeTermName = try? container.decode(String?.self, forKey: .cumulativeTermName)
        
        self.init(letterGrade: letterGrade, percentage: percentage, currentPoints: currentPoints, totalPoints: totalPoints, termName: termName, termType: termType, termID: termID, hasInitialAssignments: hasInitialAssignments, hasCompositeTasks: hasCompositeTasks, cumulativeTermName: cumulativeTermName)
    }
}
