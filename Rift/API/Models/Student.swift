//
//  Student.swift
//  Rift
//
//  Created by Varun Chitturi on 1/10/22.
//

import Foundation

struct Student: Decodable, Identifiable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let middleName: String?
    let suffix: String?
    let studentNumber: String
    let enrollments: [Enrollment]
    let futureEnrollments: [Enrollment]
    
    enum CodingKeys: String, CodingKey {
        case id = "personID"
        case firstName
        case lastName
        case middleName
        case suffix
        case studentNumber
        case enrollments
        case futureEnrollments
    }
}
