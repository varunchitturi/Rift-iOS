//
//  Assignment.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation


struct Assignment: Codable, Identifiable {
    
    let id: Int
    let assignmentName: String
    let dueDate: Date?
    let assignedDate: Date?
    let courseName: String
    let totalPoints: Int?
    let comments: String?
    let feedback: String?
    
    init(id: Int, assignmentName: String, dueDate: Date?, assignedDate: Date?, courseName: String, totalPoints: Int?, comments: String?, feedback: String?) {
        self.id = id
        self.assignmentName = assignmentName
        self.dueDate = dueDate
        self.assignedDate = assignedDate
        self.courseName = courseName
        self.totalPoints = totalPoints
        self.comments = comments
        self.feedback = feedback
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "objectSectionID"
        case assignmentName, courseName, totalPoints, dueDate, assignedDate, comments, feedback
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let assignmentName = try container.decode(String.self, forKey: .assignmentName)
        let courseName = try container.decode(String.self, forKey: .courseName)
        let totalPoints = try container.decode(Int?.self, forKey: .totalPoints)
        let dueDateString = try (container.decode(String?.self, forKey: .dueDate))
        let assignedDateString = try container.decode(String?.self, forKey: .assignedDate)
        let comments = try container.decode(String?.self, forKey: .comments)
        let feedback = try container.decode(String?.self, forKey: .feedback)
        let dateDecoder = JSONDecoder()
        dateDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso180601Full)
        
        let dueDate = dueDateString != nil ? DateFormatter.iso180601Full.date(from: dueDateString!) : nil
        let assignedDate = assignedDateString != nil ? DateFormatter.iso180601Full.date(from: assignedDateString!) : nil
        self.init(id: id, assignmentName: assignmentName, dueDate: dueDate, assignedDate: assignedDate, courseName: courseName, totalPoints: totalPoints, comments: comments, feedback: feedback)
    }
}
    


