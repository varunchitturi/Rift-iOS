//
//  Student.swift
//  Rift
//
//  Created by Varun Chitturi on 1/10/22.
//

import Foundation

/// Information on an Infinite Campus registered student
struct Student: Decodable, Identifiable {
    /// An Infinite Campus provided `id` for the student
    /// - This value is known as the `personID` in the Official Infinite Campus API
    /// - Important: Do not use this value to identify an Infinite Campus user in your app. Instead use `UserAccount.id` to identify.
    let id: Int
    
    /// The first name of the student
    let firstName: String?
    
    /// The last name of the student
    let lastName: String?
    
    /// The middle name of the student
    let middleName: String?
    
    /// Suffix name of the student
    let suffix: String?
    
    /// School given id number of the student
    let studentNumber: String
    
    /// An array of `Enrollment`s containing schools that the student currently goes to
    let enrollments: [Enrollment]
    
    /// An array of `Enrollment`s containing schools that the student plans to go to
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
