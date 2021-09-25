//
//  CourseCard.swift
//  CourseCard
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct CourseCard: View {
    
    let course: Courses.Course

    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(course.courseName)
                    Text(course.teacherName ?? "")
                        .foregroundColor(DrawingConstants.secondaryForegroundColor)
                        .fontWeight(.semibold)
                        .font(.caption)
                }
                Spacer()
                VStack {
                    CircleBadge(course.gradeDisplay?.letterGrade)
                    Text(course.gradeDisplay?.percentageString ?? "-")
                        .font(.caption)
                        .frame(width: DrawingConstants.percentageDisplayWidth)
                    
                }
            }
            .lineLimit(1)
            .foregroundColor(DrawingConstants.foregroundColor)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let backgroundColor = Color("Secondary")
        static let secondaryForegroundColor = Color("Quartenary")
        static let backgroundCornerRadius: CGFloat = 25
        static let percentageDisplayWidth: CGFloat = 80
    }
    
}

struct CourseCard_Previews: PreviewProvider {
    static let course = Courses.Course(id: 1, courseName: "AP Computer Science", teacherName: "Mr. Brucker", grades: [Courses.Grade(letterGrade: "A+", percentage: 100.0, currentPoints: 32, totalPoints: 32, termName: "Q1", termType: .midTerm)], isDropped: false)
    static var previews: some View {
        CourseCard(course: course)
            .padding()
            .previewLayout(.sizeThatFits) 
        CourseCard(course: course)
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            
    }
}
