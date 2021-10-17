//
//  CourseDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI

class CourseDetailViewModel: ObservableObject {

    @Published private var courseDetailModel: CourseDetailModel
    @Published var editingGradeDetail: GradeDetail?
    
    // TODO: make this process more effecient
    
    var courseName: String {
        courseDetailModel.course.courseName
    }
    
    var gradeDetail: GradeDetail? {
        courseDetailModel.gradeDetail
    }
    
    var courseGradeDisplay: String {
        courseDetailModel.course.gradeDisplay
    }
    
    var hasModifications: Bool {
        gradeDetail != editingGradeDetail
    }
    
    var hasGradeDetail: Bool {
        gradeDetail != nil
    }
    
    init(course: Course) {
        self.courseDetailModel = CourseDetailModel(course: course)
        API.Grades.getGradeDetails(for: course.sectionID) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(( _ , let gradeDetails)):
                    self?.courseDetailModel.gradeDetail = gradeDetails.first
                    self?.editingGradeDetail = gradeDetails.first
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
        
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
        editingGradeDetail = gradeDetail
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
