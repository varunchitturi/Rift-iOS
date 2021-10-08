//
//  CoursesModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation


struct CoursesModel {
    
    var courseList = [Course]()    
    
}

extension Course {
    var gradeDisplay: String {
        currentGrade?.letterGrade ?? "-"
    }
    
    var percentageDisplay: String {
        currentGrade?.percentageString ?? "-"
    }
}
