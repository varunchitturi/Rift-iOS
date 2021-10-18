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
            ScrollView(showsIndicators: false) {
                VStack(spacing: DrawingConstants.cardSpacing) {
                    CourseList()
                        .environmentObject(coursesViewModel)
                }
                .padding()
            }
            // TODO: change this value
            .navigationTitle(HomeModel.Tab.courses.label)
            .toolbar {
                ToolbarItem(id: UUID().uuidString) {
                    UserPreferencesSheetToggle()
                        .environmentObject(homeViewModel)
                }
            }
        }
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 15
    }
}

struct CourseList: View {
    @EnvironmentObject var coursesViewModel: CoursesViewModel
    var body: some View {
        ForEach(coursesViewModel.courseList) { course in
            if !course.isDropped {
                NavigationLink(destination: CourseDetailView(course: course)) {
                    CourseCard(course: course)
                }
            }
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel())
            .environmentObject(HomeViewModel())
    }
}
