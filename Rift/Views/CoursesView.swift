//
//  CoursesView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct CoursesView: View {
    @ObservedObject var coursesViewModel: CoursesViewModel
    
    init(locale: Locale) {
        coursesViewModel = CoursesViewModel(locale: locale)
    }
    
    var body: some View {
        ScrollView {
            ForEach(coursesViewModel.courseList) {course in
                if !course.isDropped {
                    CourseCard(courseName: course.courseName, teacher: course.teacherName, pointsEarned: course.grades?[0].currentPoints, totalPoints: course.grades?[0].totalPoints, letterGrade: course.grades?[0].letterGrade)
                }
            }
            .padding(.top)
        }
    }
}

