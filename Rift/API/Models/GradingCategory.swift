//
//  GradingCategory.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct GradingCategory: Identifiable, Decodable, Equatable {
    
    init(id: Int, name: String, isWeighted: Bool, weight: Double, isExcluded: Bool, isCalculated: Bool = false, assignments: [Assignment], categoryGrade: CategoryGrade? = nil) {
        self.id = id
        self.name = name
        self.isWeighted = isWeighted
        self.weight = weight
        self.isExcluded = isExcluded
        self.isCalculated = isCalculated
        self.assignments = assignments
        self.categoryGrade = categoryGrade
    }
    
    let id: Int
    let name: String
    let isWeighted: Bool
    let weight: Double
    let isExcluded: Bool
    var isCalculated = false
    var assignments: [Assignment] {
        didSet {
            var currentPoints: Double?
            var totalPoints: Double?
            assignments.forEach { `assignment` in
                if let assignmentScorePoints = `assignment`.scorePoints, let assignmentTotalPoints = `assignment`.totalPoints {
                    currentPoints = (currentPoints ?? 0) + assignmentScorePoints
                    totalPoints = (totalPoints ?? 0) + assignmentTotalPoints
                }
            }
            categoryGrade?.currentPoints = currentPoints
            categoryGrade?.totalPoints = totalPoints
        }
    }
    private(set) var categoryGrade: CategoryGrade?
    
    
    
    var totalPoints: Double? {
        categoryGrade?.totalPoints
    }
    
    var currentPoints: Double? {
        categoryGrade?.currentPoints
    }
    
    var percentage: Double? {
        if isCalculated {
            guard let currentPoints = currentPoints, let totalPoints = totalPoints else {
                return nil
            }
            return ((currentPoints/totalPoints) * 100).truncated(2)
        }
        return categoryGrade?.percentage
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "groupID"
        case name
        case isWeighted, isExcluded
        case assignments
        case categoryGrade = "progress"
        case weight
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let isWeighted = (try? container.decode(Bool?.self, forKey: .isWeighted)) ?? false
        let isExcluded = (try? container.decode(Bool.self, forKey: .isExcluded)) ?? true
        let assignments = (try? container.decode([Assignment]?.self, forKey: .assignments)) ?? []
        let categoryGrade = try? container.decode(CategoryGrade?.self, forKey: .categoryGrade)
        let weight = (try? container.decode(Double?.self, forKey: .weight)) ?? 0
        
        self.init(id: id, name: name, isWeighted: isWeighted, weight: weight, isExcluded: isExcluded, assignments: assignments, categoryGrade: categoryGrade)
    }
    
}
