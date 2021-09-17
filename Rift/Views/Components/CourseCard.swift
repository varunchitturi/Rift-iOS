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
                        .lineLimit(1)
                    Text(course.teacherName ?? "")
                        .foregroundColor(DrawingConstants.secondaryForegroundColor)
                        .fontWeight(.semibold)
                        .font(.caption)
                        .lineLimit(1)
                }
                .padding([.bottom], 0)
                Spacer()
                VStack {
                    Circle()
                        .fill(DrawingConstants.circleBackground)
                        .frame(minWidth: DrawingConstants.minCircleRadius,
                               maxWidth: DrawingConstants.maxCircleRadius,
                               minHeight: DrawingConstants.maxCircleRadius,
                               maxHeight: DrawingConstants.maxCircleRadius,
                               alignment: .trailing)
                        .overlay(
                            Text(course.gradeDisplay?.letterGrade ?? "N/A")
                                .fontWeight(.semibold)
                                .scaledToFill()
                                .minimumScaleFactor(0.01)
                                .foregroundColor(DrawingConstants.circleForeground)
                                .padding(9)
                        )
                    Text(course.gradeDisplay?.percentageString ?? "N/A")
                        .lineLimit(1)
                        .font(.caption)
                        .frame(width: 80)
                    
                }
            }
            .foregroundColor(DrawingConstants.foregroundColor)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private struct DrawingConstants {
        static let minCircleRadius: CGFloat = 30.0
        static let maxCircleRadius: CGFloat = 35.0
        static let foregroundColor = Color("Tertiary")
        static let backgroundColor = Color("Secondary")
        static let circleForeground = Color("Foreground")
        static let circleBackground = Color("Background")
        static let secondaryForegroundColor = Color("Quartenary")
    }
    
}

struct CourseCard_Previews: PreviewProvider {
    static let course = Courses.Course(id: 1, courseName: "AP Computer Science", teacherName: "Mr. Brucker", grades: [Courses.Grade(letterGrade: "B+", percentage: 83.3, currentPoints: 31, totalPoints: 32, termName: "Q1", termType: .midTerm)], isDropped: false)
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
