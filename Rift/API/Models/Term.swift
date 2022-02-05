//
//  Term.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct Term: Decodable, Identifiable {
    
    // TODO: see if you can combine this with GradeTerm (Json flat map)
    
    init(id: Int, termName: String, termScheduleName: String, startDate: Date, endDate: Date) {
        self.id = id
        self.termName = termName
        self.termScheduleName = termScheduleName
        self.startDate = startDate
        self.endDate = endDate
    }
    
    /// The id for this `Term`
    let id: Int
    /// The name of this `Term`
    let termName: String
    /// The schedule name for this `Term`
    let termScheduleName: String
    
    /// The start date for this `Term`
    let startDate: Date
    
    /// The end date for this `Term`
    let endDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "termID"
        case startDate, endDate
        case termName, termScheduleName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let termName = try container.decode(String.self, forKey: .termName)
        let termScheduleName = try container.decode(String.self, forKey: .termScheduleName)

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

        self.init(id: id, termName: termName, termScheduleName: termScheduleName, startDate: startDate, endDate: endDate)
    }
    
}
