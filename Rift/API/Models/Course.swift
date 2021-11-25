//
//  Course.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

struct Course: Decodable, Identifiable {
    
    init(id: Int, sectionID: Int, courseName: String, teacherName: String?, grades: [Grade]?, isDropped: Bool) {
        self.id = id
        self.sectionID = sectionID
        self.courseName = courseName
        self.teacherName = teacherName
        self.grades = grades
        self.isDropped = isDropped
    }
    
    let id: Int
    let sectionID: Int
    let courseName: String
    let teacherName: String?
    let grades: [Grade]?
    let isDropped: Bool
    
    var currentGrade: Grade? {
        grades?.first
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case courseName
        case sectionID
        case teacherName = "teacherDisplay"
        case isDropped = "dropped"
        case grades = "gradingTasks"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        let id = Int(idString) ?? UUID().hashValue
        let courseName = try container.decode(String.self, forKey: .courseName)
        let isDropped =  try container.decode(Bool.self, forKey: .isDropped)
        let grades = try container.decode([Grade]?.self, forKey: .grades)
        let teacherName = try container.decode(String.self, forKey: .teacherName)
        let sectionID = try container.decode(Int.self, forKey: .sectionID)
        self.init(id: id, sectionID: sectionID, courseName: courseName, teacherName: teacherName, grades: grades, isDropped: isDropped)
    }

}


