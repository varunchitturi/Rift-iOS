//
//  CourseDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI
import Algorithms

/// MVVM view model for the `CourseDetailView`
class CourseDetailViewModel: ObservableObject {
    
    
    /// MVVM model
    @Published private var courseDetailModel: CourseDetailModel
    
    /// An array grade details that the user can make changes to
    @Published var editingGradeDetails: [GradeDetail]?
    
    /// The index of the chosen `GradeDetail` in `courseDetailModel.gradeDetails`
    @Published var chosenGradeDetailIndex: Int?
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .loading
    

    // TODO: make this process more efficient
    
    /// The name of the `Course` that is being detailed
    var courseName: String {
        courseDetailModel.course.name
    }
    
    /// The names of the various `GradeDetail`s the user can view
    var gradeDetailOptions: [String] {
        guard let gradeDetails = courseDetailModel.gradeDetails else {
            return []
        }

        return gradeDetails.map {
            "\($0.grade.termName) \( $0.grade.termType)"
        }
    }
    
    /// The chosen `GradeDetail` based on `chosenGradeDetailIndex`
    var gradeDetail: GradeDetail? {
        guard let chosenGradeDetailIndex = chosenGradeDetailIndex, courseDetailModel.gradeDetails?.isEmpty == false else {
            return nil
        }
        return courseDetailModel.gradeDetails?[chosenGradeDetailIndex]
    }
    
    /// A copy of `gradeDetail` that the user can edit
    /// - This is the `GradeDetail` whose values are reflected in the view
    var editingGradeDetail: GradeDetail? {
        get {
            guard let chosenGradeDetailIndex = chosenGradeDetailIndex, editingGradeDetails?.isEmpty == false else {
                return nil
            }
            return editingGradeDetails?[chosenGradeDetailIndex]
        }
        set {
            guard let chosenGradeDetailIndex = chosenGradeDetailIndex, let newValue = newValue else {
                return
            }
            editingGradeDetails?[chosenGradeDetailIndex] = newValue
        }
    }
    
    /// The letter grade of the chosen `GradeDetail`
    /// - This value is always the same as the original `GradeDetail`
    /// - Does not change based on `editingGradeDetail`
    var courseGradeDisplay: String {
        String(displaying: gradeDetail?.grade.letterGrade)
    }
    
    /// A boolean value that gives if the user has made any changes to the `GradeDetail`
    /// - Checks if whether all the assignments in `editingGradeDetail` are the same as the one is `gradeDetail`
    var hasModifications: Bool {
        editingGradeDetail?.assignments != gradeDetail?.assignments
    }
    
    /// Checks if the chosen `GradeDetail` is `nil`
    var hasGradeDetail: Bool {
        gradeDetail != nil
    }

    init(course: Course, termSelectionID: Int? = nil) {
        self.courseDetailModel = CourseDetailModel(course: course, termSelectionID: termSelectionID)
        fetchGradeDetails()
    }
    
    /// Fetches grade details from the API
    func fetchGradeDetails() {
        API.Grades.getGradeDetails(for: courseDetailModel.course) {[weak self] result in

            DispatchQueue.main.async {
                switch result {
                case .success((let terms , let gradeDetails)):
                    // sort by term first, then by compositeTasks. (gradeDetails with composite tasks should go after)
                    let gradeDetails = gradeDetails.sorted { (detail1, detail2) in
                        let detail1Index = terms.firstIndex(where: {$0.id == detail1.grade.termID}) ?? -1
                        let detail2Index = terms.firstIndex(where: {$0.id == detail2.grade.termID}) ?? -1
                        if detail1Index != detail2Index {
                            return detail1Index < detail2Index
                        }
                        return detail1.grade.hasInitialAssignments
                    }
                    self?.courseDetailModel.terms = terms
                    self?.courseDetailModel.gradeDetails = gradeDetails
                    self?.editingGradeDetails = gradeDetails
                    self?.editingGradeDetails?.setCalculation(to: true)
                    self?.chosenGradeDetailIndex =  self?.courseDetailModel.gradeDetails?.firstIndex(where: {$0.grade.termID == self?.courseDetailModel.termSelectionID}) ?? self?.getCurrentGradeDetailIndex(from: terms)
                    self?.networkState = .idle
                case .failure(let error):
                    self?.networkState = .failure(error)
                }
            }
        }
    }
    
    /// Gets the index of the current `GradeDetail` based on the date
    /// - Parameter terms: The terms that each `GradeDetail` is of
    /// - Returns: The index of the current `GradeDetail`
    private func getCurrentGradeDetailIndex(from terms: [Term]) -> Int? {

        let currentDate = Date()
        for term in terms {
            if currentDate <= term.endDate {
                return courseDetailModel.gradeDetails?.firstIndex(where: {$0.grade.termID == term.id})
            }
        }
        return courseDetailModel.gradeDetails?.firstIndex {$0.grade.termID == terms.last?.id}
    }


    // MARK: - Intents
    
    /// Gets the original, unedited version of an `Assignment` based on its `id`
    /// - Parameter assignment: The `Assignment` that you are trying to get the unedited version of
    /// - Returns: The original, unedited `Assignment`
    func getOriginalAssignment(for assignment: Assignment) -> Assignment? {
        for originalAssignment in gradeDetail?.assignments ?? [] {
            if originalAssignment.id == assignment.id {
                return originalAssignment
            }
        }
        return nil
    }
    // TODO: consolidate between the word changes and modifications. Both should not be used.
    /// Resets any changes the user made to `editingGradeDetail`
    func resetChanges() {
        editingGradeDetail = gradeDetail
        editingGradeDetail?.isCalculated = true
    }
    
    /// Refreshes the view
    func rebuildView() {
        objectWillChange.send()
    }
    
    /// Deletes an `Assignment` from the assignment list of `editingGradeDetail`
    /// - Parameter assignment: The `Assignment` to delete
    func deleteAssignment(_ assignment: Assignment) {
        editingGradeDetail?.assignments.removeAll(where: {$0.id == assignment.id})
    }

}
