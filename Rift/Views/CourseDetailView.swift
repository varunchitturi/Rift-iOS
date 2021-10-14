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
        ScrollView(showsIndicators: false) {
            if courseDetailViewModel.gradeDetail != nil {
                CourseDetailStats(courseGradeDisplay: courseDetailViewModel.courseGradeDisplay, gradeDetail: courseDetailViewModel.gradeDetail!)
                    .padding(.top)
                    .padding(.horizontal)
            }
            ForEach (courseDetailViewModel.assignments) { assignment in
                NavigationLink(
                    destination: AssignmentDetailView(
                        assignment: assignment,
                        gradingCategories: courseDetailViewModel.gradeDetail?.categories ?? []
                    )
                ) {
                    CourseAssignmentCard(assignment: assignment)
                        .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
                        .padding(.vertical, DrawingConstants.cardSpacing)
                }
            }
            .navigationTitle(courseDetailViewModel.courseName)
        }
        .toolbar {
            ToolbarItem(id: UUID().uuidString) {
                Button {
                    print("add assignment")
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
       
        .onAppear {
            print(courseDetailViewModel.courseName)
        }
    }
    
    private struct DrawingConstants {
        static let cardHorizontalPadding: CGFloat = 14
        static let cardSpacing: CGFloat = 5
        // TODO: change this offset to card height * 2
        // TODO: fix buggy animations
        static let statBarCollapseOffset: CGFloat = -150
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseDetailView(course: PreviewObjects.course)
    }
}
