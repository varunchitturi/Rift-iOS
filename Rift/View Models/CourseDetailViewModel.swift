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
    @Published var chosenTermIndex: Int?
    
    // TODO: make this process more effecient
    
    var courseName: String {
        courseDetailModel.course.courseName
    }
    
    var chosenTerm: Term? {
        guard let chosenTermIndex = chosenTermIndex else {
            return nil
        }
        return courseDetailModel.terms?[chosenTermIndex]
    }
    
    var gradeDetail: GradeDetail? {
        getChosenGradeDetail(from: courseDetailModel.gradeDetails)
    }
    
    var termNames: [String] {
        guard let terms = courseDetailModel.terms else {
            return []
        }
        return terms.map { term in
            term.termName
        }
    }
    
    var editingGradeDetail: GradeDetail? {
        get {
            getChosenGradeDetail(from: editingGradeDetails)
        }
        set {
            guard editingGradeDetails != nil, let newValue = newValue else {
                return
            }
            for index in editingGradeDetails!.indices {
                if editingGradeDetails![index].id == newValue.id {
                    editingGradeDetails![index] = newValue
                }
            }
        }
    }
    
    
    
    var courseGradeDisplay: String {
        courseDetailModel.course.gradeDisplay
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
                    self?.chosenTermIndex = self?.getCurrentTermIndex(from: terms)
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
        
    }
    
    private func getCurrentTermIndex(from terms: [Term]) -> Int? {
        let currentDate = Date()
        guard !terms.isEmpty,
                currentDate >= terms.first!.startDate,
                currentDate <= terms[terms.index(before: terms.endIndex)].endDate else {
            return nil
        }
       
        if currentDate < terms.first!.startDate {
            return nil
        }
        for (index, term) in terms.enumerated() {
            if (term.startDate...term.endDate).contains(currentDate) {
                return index
            }
        }
        
        return nil
        
    }
    
    private func getChosenGradeDetail(from gradeDetails: [GradeDetail]?) -> GradeDetail? {
        guard let gradeDetails = gradeDetails else {
            return nil
        }
        
        for gradeDetail in gradeDetails {
            if gradeDetail.grade.termName == chosenTerm?.termName {
                return gradeDetail
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
