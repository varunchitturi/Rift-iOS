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
            List {
                ForEach(coursesViewModel.courseList) {course in
                    if !course.isDropped {
                        CourseCard(course: course)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, DrawingConstants.cardSpacing)
                    }
                }
                TabBar.Clearance()
            }
            .listStyle(.plain)
            .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
            // TODO: change this value
            .navigationTitle(TabBar.Tab.courses.label)
            .toolbar {
                ToolbarItem(id: UUID().uuidString) {
                    UserPreferencesButton()
                        .environmentObject(homeViewModel)
                }
            }
            
        }
        .navigationViewStyle(.stack)
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 8
        static let cardHorizontalPadding: CGFloat = 8
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel(locale: PreviewObjects.locale))
            .environmentObject(HomeViewModel(locale: PreviewObjects.locale))
    }
}
