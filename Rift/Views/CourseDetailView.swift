//
//  CourseDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import SwiftUI

struct CourseDetailView: View {
    
    @ObservedObject var courseDetailViewModel: CourseDetailViewModel
    @State private var statsAreCollapsed = false
    
    init(course: Course) {
        self.courseDetailViewModel = CourseDetailViewModel(course: course)
    }
    
    
    var body: some View {
       
        VStack {
            if courseDetailViewModel.gradeDetail != nil {
              
                CourseDetailStats(courseGradeDisplay: courseDetailViewModel.courseGradeDisplay, gradeDetail: courseDetailViewModel.gradeDetail!, isCollapsed: $statsAreCollapsed)
                    .padding(.top)
                    .padding(.horizontal)
            }
            
            ScrollView(showsIndicators: false) {
                ForEach (courseDetailViewModel.assignments) { assignment in
                    CourseAssignmentCard(assignment: assignment)
                        .padding(.horizontal, DrawingConstants.cardHorizontalPadding)
                        .padding(.vertical, DrawingConstants.cardSpacing)
                }
                .overlay(
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .named(String(describing: Self.self))).minY
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                    }
                )
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                withAnimation {
                    statsAreCollapsed = offset < DrawingConstants.statBarCollapseOffset
                }
            }
            
            .coordinateSpace(name: String(describing: Self.self))
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
