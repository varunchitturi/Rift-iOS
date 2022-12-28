//
//  Assignment.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation


/// An assignment for the user
struct Assignment: Decodable, Identifiable, Equatable {
    
    /// The id for this `Assignment`. In infinite campus, it is known as the `objectSelectionID`
    let id: Int
    
    /// Gives whether the `Assignment` is active or not
    /// - If it is active, it is included in calculating the grade for the `Assignment`'s category
    let isActive: Bool
    
    /// The `Assignment`'s name
    var name: String
    
    /// Due date for this `Assignment`
    let dueDate: Date?
    
    /// The date which this `Assignment` was assigned
    let assignedDate: Date?
    
    /// The name of the course that this `Assignment` is from
    let courseName: String
    
    /// The total points that this `Assignment` is worth
    var totalPoints: Double?
    
    /// The points earned for this `Assignment`
    var scorePoints: Double?
    
    /// Instructor comments on this `Assignment`
    let comments: String?
    
    /// The `Assignment`s score multiplier
    let multiplier: Double
    
    /// The name of the category that this `Assignment` is part of
    var categoryName: String?
    
    /// The ID of the assignment's category
    /// - This ID is used for grouping together `Assignment`s of a category
    var categoryID: Int?
    
    /// The percentage for this `Assignment`
    /// - This is calculated from the `scorePoints` and the `totalPoints`
    var percentage: Double? {
        if let totalPoints = totalPoints, let scorePoints = scorePoints {
            return ((scorePoints/totalPoints) * 100)
        }
        return nil
    }
   
    
    enum CodingKeys: String, CodingKey {
        case id = "objectSectionID"
        
        case name = "assignmentName", courseName, dueDate, assignedDate, comments, categoryName, categoryID
        
        case scorePoints, totalPoints, multiplier
        
        case isActive = "active"
    }
    
}

extension Assignment {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let isActive = try container.decode(Bool.self, forKey: .isActive)
        let courseName = try container.decode(String.self, forKey: .courseName)
        let totalPoints = try container.decode(Double?.self, forKey: .totalPoints)
        let dueDateString = try (container.decode(String?.self, forKey: .dueDate))
        let assignedDateString = try container.decode(String?.self, forKey: .assignedDate)
        let comments = try container.decode(String?.self, forKey: .comments)
        let scorePointsString = (try? container.decode(String?.self, forKey: .scorePoints)) ?? ""
        let multiplier = (try? container.decode(Double?.self, forKey: .multiplier)) ?? 1.0
        let scorePoints = Double(scorePointsString)
        
        let dueDate = dueDateString != nil ? DateFormatter.iso180601Full.date(from: dueDateString!) : nil
        let assignedDate = assignedDateString != nil ? DateFormatter.iso180601Full.date(from: assignedDateString!) : nil
        
        self.init(id: id, isActive: isActive, name: name, dueDate: dueDate, assignedDate: assignedDate, courseName: courseName, totalPoints: totalPoints, scorePoints: scorePoints, comments: comments, multiplier: multiplier, categoryName: nil, categoryID: nil)
        
    }
}
    


