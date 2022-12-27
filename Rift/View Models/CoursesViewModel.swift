//
//  CoursesViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation
import SwiftUI

/// MVVM view model for the `CoursesView`
class CoursesViewModel: ObservableObject {
    /// MVVM model
    @Published private var coursesModel: CoursesModel = CoursesModel()
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .idle
    
    /// The chosen index of the `Term` to view
    @Published var chosenTermIndex: Int?
    
    /// The chosen term based on `chosenTermIndex`
    var chosenTerm: GradeTerm? {
        guard let chosenTermIndex = chosenTermIndex else {
            return nil
        }
        return coursesModel.terms?[chosenTermIndex]
    }
    
    /// The list of courses for the user
    var courseList: [Course] {
        return chosenTerm?.courses ?? []
    }
    
    /// An array of the names of all the available terms
    var termOptions: [String] {
        (coursesModel.terms ?? []).map{ $0.name }
    }


    init() {
        fetchGrades()
    }
    
    /// Fetches the terms and courses for the user from the API
    func fetchGrades() {
        if networkState != .success {
            networkState = .loading
        }
        API.Grades.getTermGrades { [weak self] result in
            if let self {
                DispatchQueue.main.async {
                    switch result {
                    case .success(let terms):
                        self.chosenTermIndex = self.getCurrentTermIndex(from: terms)
                        self.coursesModel.terms = terms
                        self.networkState = .success
                    case .failure(let error):
                        self.networkState = .failure(error)
                    }
                }
            }
        }
    }
    
    /// Refreshes the view
    func rebuildView() {
        objectWillChange.send()
    }
    
    /// Gets the current term based on the current Date
    /// - Parameter terms: The terms to choose from
    /// - Returns: The current term the user is in
    private func getCurrentTermIndex(from terms: [GradeTerm]) -> Int? {

        let currentDate = Date()

        for (index, term) in terms.enumerated() {
            if currentDate <= term.endDate {
                return index
            }
        }
        return terms.lastIndex {$0.name == terms.last?.name}
    }
}
