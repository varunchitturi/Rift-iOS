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
    
    // TODO: make this process more effecient
    
    var courseName: String {
        courseDetailModel.course.courseName
    }
    
    var gradeDetailOptions: [String] {
        guard let gradeDetails = courseDetailModel.gradeDetails else {
            return []
        }
        
        return gradeDetails.filter({$0.grade.hasCompositeTasks || $0.grade.isIndividualGrade}).map {
            "\($0.grade.termName) \( $0.grade.termType)"
        }
    }
    
    var gradeDetail: GradeDetail? {
        guard let chosenGradeDetailIndex = chosenGradeDetailIndex else {
            return nil
        }
        return courseDetailModel.gradeDetails?[chosenGradeDetailIndex]
    }
    
    var editingGradeDetail: GradeDetail? {
        get {
            guard let chosenGradeDetailIndex = chosenGradeDetailIndex else {
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
        gradeDetail?.grade.letterGrade ?? Text.nilStringText
    }
    
    var hasModifications: Bool {
        courseDetailModel.gradeDetails != editingGradeDetails
    }
    
    var hasGradeDetail: Bool {
        gradeDetail != nil
    }
    
    init(course: Course) {
        self.courseDetailModel = CourseDetailModel(course: course)
        API.Grades.getGradeDetails(for: course.sectionID) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success((let terms , let gradeDetails)):
                    self?.courseDetailModel.terms = terms
                    self?.courseDetailModel.gradeDetails = gradeDetails
                    self?.editingGradeDetails = gradeDetails
                    self?.chosenGradeDetailIndex = self?.getCurrentGradeDetailIndex(from: terms)
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
        
    }
    
    private func getCurrentGradeDetailIndex(from terms: [Term]) -> Int? {
        let currentDate = Date()
        guard !terms.isEmpty,
                currentDate >= terms.first!.startDate,
                currentDate <= terms[terms.index(before: terms.endIndex)].endDate else {
            return nil
        }
        
        for term in terms {
            if (term.startDate...term.endDate).contains(currentDate) {
                return courseDetailModel.gradeDetails?.firstIndex(where: {$0.grade.termName == term.termName && !$0.grade.isIndividualGrade}) ??
                    courseDetailModel.gradeDetails?.firstIndex(where: {$0.grade.termName == term.termName})
            }
        }
        
        return nil
    }
    
    
    // MARK: - Intents
    
    func getOriginalAssignment(for assignment: Assignment) -> Assignment {
        for originalAssignment in gradeDetail?.assignments ?? [] {
            if originalAssignment.id == assignment.id {
                return originalAssignment
            }
        }
        return Assignment(id: assignment.id,
                          isActive: true,
                          assignmentName: assignment.assignmentName,
                          dueDate: nil,
                          assignedDate: nil,
                          courseName: assignment.courseName,
                          totalPoints: nil,
                          scorePoints: nil,
                          comments: nil,
                          categoryName: assignment.categoryName,
                          categoryID: assignment.categoryID
        )
    }
    // TODO: consolidate between the word changes and modifications. Both should not be used.
    func resetChanges() {
        editingGradeDetails = courseDetailModel.gradeDetails
    }
    
    func refreshView() {
        objectWillChange.send()
    }
    
    func deleteAssignment(_ assignment: Assignment) {
        editingGradeDetail?.assignments.removeAll(where: {$0.id == assignment.id})
    }
  
}

extension GradingCategory {
    var percentageDisplay: String {
        percentage?.truncated(2).description.appending("%") ?? Text.nilStringText
    }
}

extension GradeDetail {
    var totalPercentageDisplay: String {
        totalPercentage?.truncated(2).description.appending("%") ?? Text.nilStringText
    }
}
