//
//  CoursesViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation
import SwiftUI

class CoursesViewModel: ObservableObject {
    @Published private var coursesModel: CoursesModel = CoursesModel()
    var courseList: [Course] {
        coursesModel.courseList
    }
    
    init() {
        API.Grades.getTermGrades { result in
            // TODO: do better term finding in API implementation
            DispatchQueue.main.async {
                switch result {
                case .success(let terms):
                    self.coursesModel.courseList = !terms.isEmpty ? terms[0].courses ?? [] : []
                case .failure(let error):
                    // TODO: do bettter error handling here
                    print("Courses error")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func rebuildView() {
        objectWillChange.send()
    }
}
