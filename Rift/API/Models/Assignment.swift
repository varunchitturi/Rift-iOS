//
//  Assignment.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation


struct Assignment: Codable, Identifiable {
    
    let id: Int
    let isActive: Bool
    let assignmentName: String
    let dueDate: Date?
    let assignedDate: Date?
    let courseName: String
    var totalPoints: Double?
    var scorePoints: Double?
    let comments: String?
    var categoryName: String?
    var categoryID: Int?
  
    
    enum CodingKeys: String, CodingKey {
        case id = "objectSectionID"
        
        case assignmentName, courseName, dueDate, assignedDate, comments, categoryName, categoryID
        
        case scorePoints, totalPoints
        
        case isActive = "active"
    }
    
}

extension Assignment {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let assignmentName = try container.decode(String.self, forKey: .assignmentName)
        let isActive = try container.decode(Bool.self, forKey: .isActive)
        let courseName = try container.decode(String.self, forKey: .courseName)
        let totalPoints = try container.decode(Double?.self, forKey: .totalPoints)
        let dueDateString = try (container.decode(String?.self, forKey: .dueDate))
        let assignedDateString = try container.decode(String?.self, forKey: .assignedDate)
        let comments = try container.decode(String?.self, forKey: .comments)
        let scorePointsString = try container.decode(String?.self, forKey: .scorePoints)
        let scorePoints = Double(scorePointsString ?? "")
        
        let dueDate = dueDateString != nil ? DateFormatter.iso180601Full.date(from: dueDateString!) : nil
        let assignedDate = assignedDateString != nil ? DateFormatter.iso180601Full.date(from: assignedDateString!) : nil
        
        self.init(id: id, isActive: isActive, assignmentName: assignmentName, dueDate: dueDate, assignedDate: assignedDate, courseName: courseName, totalPoints: totalPoints, scorePoints: scorePoints, comments: comments, categoryName: nil, categoryID: nil)
        
    }
}
    


