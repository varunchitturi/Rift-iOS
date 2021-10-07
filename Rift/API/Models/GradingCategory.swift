//
//  GradingCategory.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct GradingCategory: Identifiable, Codable {
    let id: Int
    let name: String
    let isWeighted: Bool
    var assignments: [Assignment]
    
    enum CodingKeys: String, CodingKey {
        case id = "groupID"
        case name
        case isWeighted
        case assignments
    }
    
}
