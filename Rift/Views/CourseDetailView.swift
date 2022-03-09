//
//  CourseDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import SwiftUI

struct CourseDetailView: View {
    
    @ObservedObject var courseDetailViewModel: CourseDetailViewModel
    @State private var addAssignmentIsPresented = false
    @State private var gradeDetailChoiceIsEditing = false
    @State private var showCalculatedGrade = true
    
    init(course: Course, termSelectionID: Int? = nil) {
        self.courseDetailViewModel = CourseDetailViewModel(course: course, termSelectionID: termSelectionID)
    }
    
    
    var body: some View {
        // TODO: change background color if assignment is edited
        ScrollView(showsIndicators: false) {
            VStack(spacing: DrawingConstants.cardSpacing) {
                
                HStack {
                    VStack {
                        CircleBadge(courseDetailViewModel.courseGradeDisplay, size: .large)
                    }
    
                    CapsuleDropDown(description: "Choose a Term", options: courseDetailViewModel.gradeDetailOptions, selectionIndex: $courseDetailViewModel.chosenGradeDetailIndex, isEditing: $gradeDetailChoiceIsEditing)
                }
                HStack {
                    Toggle(isOn: $showCalculatedGrade) {
                        Text("Show Calculated")
                            .foregroundColor(Rift.DrawingConstants.foregroundColor)
                    }
                }
                if courseDetailViewModel.hasGradeDetail {
                    CourseDetailStats(
                        gradeDetail: courseDetailViewModel.gradeDetail!,
                        editingGradeDetail: courseDetailViewModel.editingGradeDetail!,
                        showCalculatedGrade: showCalculatedGrade
                    )
                    ForEach ($courseDetailViewModel.editingGradeDetail.unwrap()!.assignments) { `assignment` in
                        NavigationLink(
                            destination: AssignmentDetailView(
                                    // TODO: make this more efficient. Calculate get original assignment only after navigation
                                    originalAssignment: courseDetailViewModel.getOriginalAssignment(for: `assignment`.wrappedValue),
                                    assignmentToEdit: `assignment`,
                                    gradingCategories: courseDetailViewModel.editingGradeDetail!.categories
                                )
                                .environmentObject(courseDetailViewModel)
                        ) {
                            CourseAssignmentCard(assignment: `assignment`.wrappedValue)
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    if courseDetailViewModel.hasGradeDetail {
                        Button {
                            addAssignmentIsPresented = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    if courseDetailViewModel.hasModifications {
                        Button {
                            withAnimation {
                                courseDetailViewModel.resetChanges()
                            }
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: courseDetailViewModel.hasModifications)
            }
        }
        .sheet(isPresented: $addAssignmentIsPresented) {
            if courseDetailViewModel.editingGradeDetail != nil {
                AddAssignmentView(courseName: courseDetailViewModel.courseName, assignments: $courseDetailViewModel.editingGradeDetail.unwrap()!.assignments, gradingCategories: courseDetailViewModel.editingGradeDetail!.categories)
            }
            
        }
        .navigationTitle(courseDetailViewModel.courseName)
        .logViewAnalytics(self)
    }
    
    private enum DrawingConstants {
        static let cardSpacing: CGFloat = 15
    }
}

#if DEBUG
struct CourseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseDetailView(course: PreviewObjects.course)
            .previewDevice("iPhone 13")
    }
}
#endif
