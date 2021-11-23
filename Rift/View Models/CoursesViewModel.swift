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
        API.Grades.getTermGrades { [weak self] result in
            // TODO: do better term finding in API implementation
            DispatchQueue.main.async {
                switch result {
                case .success(let terms):
                    // TODO: change this so that you aren't just getting the first term
                    self?.coursesModel.courseList = self?.getCurrentTerm(from: terms)?.courses ?? []
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
    
    private func getCurrentTerm(from terms: [GradeTerm]) -> GradeTerm? {
        let currentDate = Date()
        guard !terms.isEmpty,
                currentDate >= terms.first!.startDate,
                currentDate <= terms[terms.index(before: terms.endIndex)].endDate else {
            return nil
        }
        return terms.first(where: {($0.startDate...$0.endDate).contains(currentDate)})
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
