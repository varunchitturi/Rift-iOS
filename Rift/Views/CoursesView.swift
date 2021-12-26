//
//  CoursesView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI
import Shimmer

struct CoursesView: View {
    @ObservedObject var coursesViewModel: CoursesViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var termChoiceIsEditing = false
    init(viewModel: CoursesViewModel) {
        coursesViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: DrawingConstants.cardSpacing) {
                    if !coursesViewModel.termOptions.isEmpty {
                        CapsuleDropDown("Term", description: "Choose a Term", options: coursesViewModel.termOptions, selectionIndex: $coursesViewModel.chosenTermIndex, isEditing: $termChoiceIsEditing)
                    }
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
                NavigationLink(destination: CourseDetailView(course: course, termSelectionID: coursesViewModel.chosenTerm?.id)) {
                    CourseCard(course: course)
                }
            }
        }
        .skeletonLoad(coursesViewModel.responseState == .loading) {
            CapsuleTextField(text: .constant(""), isEditing: .constant(false))
                .redacted(reason: .placeholder)
                .shimmering()
            ForEach(0..<DrawingConstants.placeholderCourseCount) { _ in
                CourseCard()
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }
    
    private struct DrawingConstants {
        static let placeholderCourseCount = 6
    }
}

#if DEBUG
struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel())
            .environmentObject(HomeViewModel())
    }
}
#endif
