//
//  GradeTerm.swift
//  Rift
//
//  Created by Varun Chitturi on 10/5/21.
//

import Foundation
import SwiftUI

/// Similar to `Term` but isn't specific to a course
struct GradeTerm: Decodable, Identifiable {
    
    init(id: Int, startDate: Date, endDate: Date, name: String, termScheduleName: String, courses: [Course]?) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.termScheduleName = termScheduleName
        self.courses = courses
    }
    
    /// The `id` for this `GradeTerm`
    let id: Int
    
    /// When the `GradeTerm` starts
    let startDate: Date
    
    /// When the `GradeTerm` ends
    let endDate: Date
    
    /// The name of the `GradeTerm`
    let name: String
    
    /// The schedule name for this `GradeTerm`
    /// - Gives information on the grading period
    /// - Example: Quarters, Semesters, Trimesters
    let termScheduleName: String
    
    /// All the courses in this `GradeTerm`
    let courses: [Course]?
    
    enum CodingKeys: String, CodingKey {
        case id = "termID"
        case startDate, endDate
        case name="termName"
        case termScheduleName
        case courses
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let termScheduleName = try container.decode(String.self, forKey: .termScheduleName)
        let courses = try container.decode([Course]?.self, forKey: .courses)
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        let endDateString = try container.decode(String.self, forKey: .endDate)
        
        let startDate = DateFormatter.yearMonthDayDashedUTC.date(from: startDateString)
        let endDate = DateFormatter.yearMonthDayDashedUTC.date(from: endDateString)
        
        guard let startDate = startDate else {
            throw DecodingError.dateDecodingError(for: [CodingKeys.startDate])
        }
        guard let endDate = endDate else {
            throw DecodingError.dateDecodingError(for: [CodingKeys.endDate])
        }
        
        self.init(id: id, startDate: startDate, endDate: endDate, name: name, termScheduleName: termScheduleName, courses: courses)
    }
}
