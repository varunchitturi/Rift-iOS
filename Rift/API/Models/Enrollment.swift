//
//  Enrollment.swift
//  Rift
//
//  Created by Varun Chitturi on 1/10/22.
//

import Foundation

/// Gives information on the institution that a student is enrolled in
struct Enrollment: Decodable, Identifiable {
    
    /// The `id` of the institution
    let id: Int
    
    /// An `id` given to identify a student
    /// - Important: Do not use this to identify Infinite Campus users across your app
    let personID: Int
    
    /// An `id` given to identify structures from this `Enrollment`
    let structureID: Int
    
    /// The `id` of the school
    let schoolID: Int
    
    /// The end year for this `Enrollment`
    let endYear: Int
    
    /// The start year for this `Enrollment`
    let startDate: Date
    
    /// The grade the student is enrolling in at the school
    let grade: String
    
    /// The name of the school
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
