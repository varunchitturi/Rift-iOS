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
                Spacer(minLength: DrawingConstants.scrollViewTopInsetPadding)
                ForEach(coursesViewModel.courseList) {course in
                    if !course.isDropped {
                        CourseCard(course: course)
                            .padding(.vertical, DrawingConstants.cardSpacing)
                    }
                }
            }
            .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
            // TODO: change this value
            .navigationTitle(Home.Tab.courses.label)
            .toolbar {
                ToolbarItem(id: UUID().uuidString) {
                    UserPreferencesSheetToggle()
                        .environmentObject(homeViewModel)
                }
            }
            .onAppear {
                // TODO: explain this
                coursesViewModel.rebuildView()
            }
            
        }
        .navigationViewStyle(.stack)
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 3
        static let cardHorizontalPadding: CGFloat = 14
        static let scrollViewTopInsetPadding: CGFloat = 12
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel())
            .environmentObject(HomeViewModel())
    }
}
