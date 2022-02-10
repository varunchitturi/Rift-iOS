//
//  CourseDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI
import Algorithms

class CourseDetailViewModel: ObservableObject {

    @Published private var courseDetailModel: CourseDetailModel
    @Published var editingGradeDetails: [GradeDetail]?
    @Published var chosenGradeDetailIndex: Int?
    @Published var networkState: AsyncState = .loading

    // TODO: make this process more efficient

    var courseName: String {
        courseDetailModel.course.name
    }

    var gradeDetailOptions: [String] {
        guard let gradeDetails = courseDetailModel.gradeDetails else {
            return []
        }

        return gradeDetails.map {
            "\($0.grade.termName) \( $0.grade.termType)"
        }
    }

    var gradeDetail: GradeDetail? {
        guard let chosenGradeDetailIndex = chosenGradeDetailIndex, courseDetailModel.gradeDetails?.isEmpty == false else {
            return nil
        }
        return courseDetailModel.gradeDetails?[chosenGradeDetailIndex]
    }

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

    var courseGradeDisplay: String {
        String(displaying: gradeDetail?.grade.letterGrade)
    }

    var hasModifications: Bool {
        editingGradeDetail?.assignments != gradeDetail?.assignments
    }

    var hasGradeDetail: Bool {
        gradeDetail != nil
    }

    init(course: Course, termSelectionID: Int? = nil) {
        self.courseDetailModel = CourseDetailModel(course: course, termSelectionID: termSelectionID)
        fetchGradeDetails()
    }

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
                    // TODO: better error handling here
                    self?.networkState = .failure(error)
                    print(error)
                }
            }
        }
    }

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

    func getOriginalAssignment(for assignment: Assignment) -> Assignment? {
        for originalAssignment in gradeDetail?.assignments ?? [] {
            if originalAssignment.id == assignment.id {
                return originalAssignment
            }
        }
        return nil
    }
    // TODO: consolidate between the word changes and modifications. Both should not be used.
    func resetChanges() {
        editingGradeDetail = gradeDetail
        editingGradeDetail?.isCalculated = true
    }

    func rebuildView() {
        objectWillChange.send()
    }

    func deleteAssignment(_ assignment: Assignment) {
        editingGradeDetail?.assignments.removeAll(where: {$0.id == assignment.id})
    }

}
