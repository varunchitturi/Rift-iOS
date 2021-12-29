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
    @Published var networkState: AsyncState = .idle
    @Published var chosenTermIndex: Int?

    var chosenTerm: GradeTerm? {
        guard let chosenTermIndex = chosenTermIndex else {
            return nil
        }
        return coursesModel.terms?[chosenTermIndex]
    }

    var courseList: [Course] {
        return chosenTerm?.courses ?? []
    }

    var termOptions: [String] {
        (coursesModel.terms ?? []).map{ $0.termName }
    }



    init() {
        fetchGrades()
    }

    func fetchGrades() {
        networkState = .loading
        API.Grades.getTermGrades { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let terms):
                    self?.chosenTermIndex = self?.getCurrentTermIndex(from: terms)
                    self?.coursesModel.terms = terms
                    self?.networkState = .success
                case .failure(let error):
                    // TODO: do bettter error handling here
                    self?.networkState = .failure(error)
                    print("Courses error")
                    print(error.localizedDescription)
                }
            }
        }
    }


    func rebuildView() {
        objectWillChange.send()
    }

    private func getCurrentTermIndex(from terms: [GradeTerm]) -> Int? {

        let currentDate = Date()

        for (index, term) in terms.enumerated() {
            if currentDate <= term.endDate {
                return index
            }
        }
        return terms.lastIndex {$0.termName == terms.last?.termName}
    }
}
