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
                    // TODO: change this so that you aren't just getting the first term
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

extension Course {
    var gradeDisplay: String {
        currentGrade?.letterGrade ?? Text.nilStringText
    }
    
    var percentageDisplay: String {
        currentGrade?.percentageString ?? Text.nilStringText
    }
}

extension Grade {
    var percentageString: String {
        guard let percentage = percentage?.description else {
            if let totalPoints = totalPoints, let currentPoints = currentPoints {
                return (((currentPoints / totalPoints) * 100).rounded(2)).description.appending("%")
            } else {
                return Text.nilStringText
            }
            
        }
        return percentage.appending("%")
    }

}
