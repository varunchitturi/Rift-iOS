//
//  Enrollment.swift
//  Rift
//
//  Created by Varun Chitturi on 1/10/22.
//

import Foundation

struct Enrollment: Decodable, Identifiable {
    let id: Int
    let personID: Int
    let structureID: Int
    let schoolID: Int
    let endYear: Int
    let startDate: Date
    let grade: String
    let schoolName: String

    
    enum CodingKeys: String, CodingKey {
        case id = "enrollmentID"
        case personID
        case structureID
        case schoolID
        case endYear
        case startDate
        case grade
        case schoolName
    }
}

extension Enrollment {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let personID = try container.decode(Int.self, forKey: .personID)
        let structureID = try container.decode(Int.self, forKey: .structureID)
        let schoolID = try container.decode(Int.self, forKey: .schoolID)
        let startDateString = try container.decode(String.self, forKey: .startDate)
        let endYear = try container.decode(Int.self, forKey: .endYear)
        let schoolName = try container.decode(String.self, forKey: .schoolName)
        let grade = try container.decode(String.self, forKey: .grade)
        let startDate = DateFormatter.yearMonthDayDashedUTC.date(from: startDateString)
        
        guard let startDate = startDate else {
            throw DecodingError.dateDecodingError(for: [CodingKeys.startDate])
        }

        
        self.init(id: id, personID: personID, structureID: structureID, schoolID: schoolID, endYear: endYear, startDate: startDate, grade: grade, schoolName: schoolName)
    }
}
