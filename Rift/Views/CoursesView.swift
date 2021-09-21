//
//  CoursesView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct CoursesView: View {
    @ObservedObject var coursesViewModel: CoursesViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
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
            // TODO: change this value
            .navigationTitle(TabBar.Tab.courses.rawValue)
            .toolbar {
                UserPreferencesButton()
                    .environmentObject(homeViewModel)
            }
            
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 12
        static let cardHorizontalPadding: CGFloat = 8
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel(locale: PreviewObjects.locale))
            .environmentObject(HomeViewModel(locale: PreviewObjects.locale))
    }
}
