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
        ScrollView {
            ForEach (courseDetailViewModel.assignments) { assignment in
                CourseAssignmentCard(assignment: assignment)
                    .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
                    .padding(.vertical, DrawingConstants.cardSpacing)
            }
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
