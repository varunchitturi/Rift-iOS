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
    
    enum CodingKeys: String, CodingKey {
        case grade = "task"
        case categories
    }
}
