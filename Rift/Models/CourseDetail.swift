//
//  CourseDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

struct CourseDetail {
    // TODO: handle errors when locale doesnt exist
    
    let course: Course
    
    let assignments: [Assignment]
    
    let detail: GradeDetail
    
}
