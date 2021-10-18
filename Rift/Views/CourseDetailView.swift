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
    
    init(course: Course) {
        self.courseDetailViewModel = CourseDetailViewModel(course: course)
    }
    
    
    var body: some View {
        // TODO: change background color if assignment is edited
        ScrollView(showsIndicators: false) {
            VStack(spacing: DrawingConstants.cardSpacing) {
                if courseDetailViewModel.hasGradeDetail {
                    CourseDetailStats(courseGradeDisplay: courseDetailViewModel.courseGradeDisplay, gradeDetail: courseDetailViewModel.gradeDetail!, editingGradeDetail: courseDetailViewModel.editingGradeDetail!)
                        .padding(.bottom)
                    ForEach ($courseDetailViewModel.editingGradeDetail.unwrap()!.assignments) { `assignment` in
                        NavigationLink(
                            destination: AssignmentDetailView(
                                // TODO: make this more effecient. Calculate get orignal assignment only after navigation
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
        .onAppear {
            courseDetailViewModel.refreshView()
        }
        .sheet(isPresented: $addAssignmentIsPresented) {
            if courseDetailViewModel.editingGradeDetail != nil {
                AddAssignmentView(courseName: courseDetailViewModel.courseName, assignments: $courseDetailViewModel.editingGradeDetail.unwrap()!.assignments, gradingCategories: courseDetailViewModel.editingGradeDetail!.categories)
            }
            
        }
        .navigationTitle(courseDetailViewModel.courseName)
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 15
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseDetailView(course: PreviewObjects.course)
    }
}
