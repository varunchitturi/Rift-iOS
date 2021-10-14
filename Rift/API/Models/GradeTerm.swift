//
//  GradeTerm.swift
//  Rift
//
//  Created by Varun Chitturi on 10/5/21.
//

import Foundation
import SwiftUI

struct GradeTerm: Codable, Identifiable {
    
    init(id: Int, startDate: Date, endDate: Date, termName: String, termScheduleName: String, courses: [Course]?) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.termName = termName
        self.termScheduleName = termScheduleName
        self.courses = courses
    }
    
    let id: Int
    let startDate: Date
    let endDate: Date
    let termName: String
    let termScheduleName: String
    let courses: [Course]?
    
    enum CodingKeys: String, CodingKey {
        case id = "termID"
        case startDate, endDate
        case termName, termScheduleName
        case courses
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let termName = try container.decode(String.self, forKey: .termName)
        let termScheduleName = try container.decode(String.self, forKey: .termScheduleName)
        let courses = try container.decode([Course]?.self, forKey: .courses)
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        let endDateString = try container.decode(String.self, forKey: .endDate)
        
        let dateDecoder = JSONDecoder()
        dateDecoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDayDashedUTC)
        
        let startDate = DateFormatter.yearMonthDayDashedUTC.date(from: startDateString)
        let endDate = DateFormatter.yearMonthDayDashedUTC.date(from: endDateString)
        
        guard let startDate = startDate else {
            throw DecodingError.dateDecodingError(for: [CodingKeys.startDate])
        }
        guard let endDate = endDate else {
            throw DecodingError.dateDecodingError(for: [CodingKeys.endDate])
        }
        
        self.init(id: id, startDate: startDate, endDate: endDate, termName: termName, termScheduleName: termScheduleName, courses: courses)
    }
}
