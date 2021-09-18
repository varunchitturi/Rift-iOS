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
        NavigationView {
            ScrollView {
                LazyVStack(spacing: DrawingConstants.cardSpacing) {
                    ForEach(coursesViewModel.courseList) {course in
                        if !course.isDropped {
                            CourseCard(course: course)
                        }
                    }
                }
                .padding(.top)
                .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
            }
            .navigationTitle(TabBar.Tab.courses.rawValue)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 8
        static let cardHorizontalPadding: CGFloat = 4
    }
}

