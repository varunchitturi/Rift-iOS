//
//  CoursesViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation
import SwiftUI

class CoursesViewModel: ObservableObject {
    @Published private var courses: Courses
    var courseList: [Courses.Course] {
        courses.courseList
    }
    
    init(locale: Locale) {
        courses = Courses(locale: locale)
        courses.getCourses {result in
            switch result {
            case .success(let courseList):
                self.courses.courseList.append(contentsOf: courseList)
            case .failure(let error):
                // TODO: do bettter error handling here
                print(error.localizedDescription)
            }
        }
    }
}
