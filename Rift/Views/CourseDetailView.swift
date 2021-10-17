//
//  CourseDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import SwiftUI

struct CourseDetailView: View {
    
    @ObservedObject var courseDetailViewModel: CourseDetailViewModel
    
    init(course: Course) {
        self.courseDetailViewModel = CourseDetailViewModel(course: course)
    }
    
    
    var body: some View {
        // TODO: change background color if assignment is edited
        ScrollView(showsIndicators: false) {
            if courseDetailViewModel.gradeDetail != nil {
                CourseDetailStats(courseGradeDisplay: courseDetailViewModel.courseGradeDisplay, gradeDetail: courseDetailViewModel.gradeDetail!, editingGradeDetail: courseDetailViewModel.editingGradeDetail!)
                    .padding(.top)
                    .padding(.horizontal)
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
                    .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
                    .padding(.vertical, DrawingConstants.cardSpacing)
                }
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        print("add assignment")
                    } label: {
                        Image(systemName: "plus")
                    }
                    if courseDetailViewModel.hasModifications {
                        Button {
                            courseDetailViewModel.resetChanges()
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
        .navigationTitle(courseDetailViewModel.courseName)
    }
    
    private struct DrawingConstants {
        static let cardHorizontalPadding: CGFloat = 14
        static let cardSpacing: CGFloat = 5
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseDetailView(course: PreviewObjects.course)
    }
}
