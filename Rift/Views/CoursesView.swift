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
            .apiHandler(asyncState: coursesViewModel.networkState, loadingView: {
                CourseLoadingView()
            }, retryAction: { _ in
                coursesViewModel.fetchGrades()
            })
            .navigationTitle(HomeModel.Tab.courses.label)
            .toolbar {
                ToolbarItem(id: UUID().uuidString) {
                    UserPreferencesSheetToggle()
                        .environmentObject(homeViewModel)
                }
            }
            .refreshable {
                coursesViewModel.fetchGrades()
            }
        }
    }

    private enum DrawingConstants {
        static let cardSpacing: CGFloat = 15
        
    }
}

private struct CourseLoadingView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    CapsuleTextField(text: .constant(""), isEditing: .constant(false))
                    ForEach(0..<DrawingConstants.placeholderCourseCount, id: \.self) { _ in
                        CourseCard()
                    }
                }
                .skeletonLoad()
            }
            .padding()
        }
    }
    
    private enum DrawingConstants {
        static let placeholderCourseCount = 6
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
        .logViewAnalytics(self)
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
