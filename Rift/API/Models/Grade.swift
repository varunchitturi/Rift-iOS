//
//  Grade.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation



struct Grade: Decodable, Equatable {
    
    init(letterGrade: String?, percentage: Double?, currentPoints: Double?, totalPoints: Double?, termName: String, termType: String, groupWeighted: Bool, isIndividualGrade: Bool, hasCompositeTasks: Bool, cumulativeTermName: String?) {
        self.letterGrade = letterGrade
        self.percentage = percentage
        self.currentPoints = currentPoints
        self.totalPoints = totalPoints
        self.termName = termName
        self.termType = termType
        self.groupWeighted = groupWeighted
        self.isIndividualGrade = isIndividualGrade
        self.hasCompositeTasks = hasCompositeTasks
        self.cumulativeTermName = cumulativeTermName
    }
    
    var letterGrade: String?
    let percentage: Double?
    let currentPoints: Double?
    let totalPoints: Double?
    let termName: String
    let termType: String
    var groupWeighted: Bool
    let isIndividualGrade: Bool
    let hasCompositeTasks: Bool
    let cumulativeTermName: String?

    enum CodingKeys: String, CodingKey {
        case letterGrade = "progressScore"
        case score
        case percentage = "progressPercent"
        case percent
        case currentPoints = "progressPointsEarned"
        case totalPoints = "progressTotalPoints"
        case termName
        case termType = "taskName"
        case groupWeighted
        case isIndividualGrade = "hasAssignments"
        case hasCompositeTasks
        case cumulativeTermName
        
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let letterGrade = (try? container.decode(String?.self, forKey: .letterGrade)) ??
                        (try? container.decode(String?.self, forKey: .score))
    
        let percentage = (try? container.decode(Double?.self, forKey: .percentage)) ??
                        (try? container.decode(Double?.self, forKey: .percent))
        
        let currentPoints = try? container.decode(Double?.self, forKey: .currentPoints)
        let totalPoints = try? container.decode(Double?.self, forKey: .totalPoints)
        let termName = try container.decode(String.self, forKey: .termName)
        let termType = try container.decode(String.self, forKey: .termType)
        let groupWeighted = (try? container.decode(Bool?.self, forKey: .groupWeighted)) ?? false
        let isIndividualGrade = try container.decode(Bool.self, forKey: .isIndividualGrade)
        let hasCompositeTasks = try container.decode(Bool.self, forKey: .hasCompositeTasks)
        let cumulativeTermName = try? container.decode(String?.self, forKey: .cumulativeTermName)
        
        self.init(letterGrade: letterGrade, percentage: percentage, currentPoints: currentPoints, totalPoints: totalPoints, termName: termName, termType: termType, groupWeighted: groupWeighted, isIndividualGrade: isIndividualGrade, hasCompositeTasks: hasCompositeTasks, cumulativeTermName: cumulativeTermName)
    }
    
}




