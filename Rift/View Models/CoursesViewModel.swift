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
    @Published var responseState: ResponseState = .idle
    var courseList: [Course] {
        coursesModel.courseList
    }
    
    init() {
        responseState = .loading
        API.Grades.getTermGrades { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let terms):
                    self?.coursesModel.courseList = self?.getCurrentTerm(from: terms)?.courses ?? []
                    self?.responseState = .idle
                case .failure(let error):
                    // TODO: do bettter error handling here
                    self?.responseState = .failure(error: error)
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

