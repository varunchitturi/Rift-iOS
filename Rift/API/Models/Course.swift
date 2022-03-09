//
//  Course.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

struct Course: Decodable, Identifiable {
    
    init(id: Int, sectionID: Int, name: String, teacherName: String?, grades: [Grade]?, isDropped: Bool) {
        self.id = id
        self.sectionID = sectionID
        self.name = name
        self.teacherName = teacherName
        self.grades = grades
        self.isDropped = isDropped
    }
    
    /// The ID for this course
    let id: Int
    
    /// The sectionID for this course
    /// - This should be used in order get detail information for this course
    let sectionID: Int
    
    /// The name of the course
    let name: String
    
    /// The name of the teacher for this course
    let teacherName: String?
    
    /// The grades for this course
    /// - The grades in this array defer by term type.
    /// - For example: mid-term grade and quarter grade for the current term.
    let grades: [Grade]?
    
    /// Gives whether this course is dropped or not
    let isDropped: Bool
    
    /// Tries to get the first grade that has a letter grade or just the first grade from the `grades` array
    var currentGrade: Grade? {
        return grades?.first(where: {$0.letterGrade != nil}) ?? grades?.first
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "courseName"
        case sectionID
        case teacherName = "teacherDisplay"
        case isDropped = "dropped"
        case grades = "gradingTasks"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        let id = Int(idString) ?? UUID().hashValue
        let name = try container.decode(String.self, forKey: .name)
        let isDropped =  try container.decode(Bool.self, forKey: .isDropped)
        let grades = try container.decode([Grade]?.self, forKey: .grades)
        let teacherName = try container.decode(String.self, forKey: .teacherName)
        let sectionID = try container.decode(Int.self, forKey: .sectionID)
        self.init(id: id, sectionID: sectionID, name: name, teacherName: teacherName, grades: grades, isDropped: isDropped)
    }

}


