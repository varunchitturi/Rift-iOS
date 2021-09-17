//
//  CoursesView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct CoursesView: View {
    @ObservedObject var coursesViewModel: CoursesViewModel
    
    init(viewModel: CoursesViewModel) {
        coursesViewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            ForEach(coursesViewModel.courseList) {course in
                if !course.isDropped {
                    CourseCard(course: course)
                        .padding(.horizontal, DrawingConstants.cardEdgePadding)
                }
            }
            .padding(.top)
        }
    }
    
    private struct DrawingConstants {
        static let cardEdgePadding: CGFloat = 2
    }
}

