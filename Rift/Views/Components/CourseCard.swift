//
//  CourseCard.swift
//  CourseCard
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct CourseCard: View {
    
    let course: Course

    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(course.name)
                    Text(course.teacherName ?? "")
                        .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                        .fontWeight(.semibold)
                        .font(.caption)
                }
                Spacer()
                VStack {
                    CircleBadge(String(displaying: course.currentGrade?.letterGrade))
                    Text(String(displaying: course.currentGrade?.percentage, style: .percentage, roundedTo: Rift.DrawingConstants.decimalCutoff))
                        .font(.caption)
                        .frame(width: DrawingConstants.percentageDisplayWidth)
                    
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                    .font(.callout.bold())
            }
            .lineLimit(1)
            .foregroundColor(Rift.DrawingConstants.foregroundColor)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(Rift.DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
        
    }
    
    private enum DrawingConstants {
        static let backgroundCornerRadius: CGFloat = 20
        static let percentageDisplayWidth: CGFloat = 80
    }
    
}

extension CourseCard {
    init() {
        course = Course(
            id: UUID().hashValue,
            sectionID: UUID().hashValue,
            name: "Course Name",
            teacherName: "Teacher Name",
            grades: nil,
            isDropped: false
        )
    }
}

#if DEBUG
struct CourseCard_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ScrollView {
                ForEach(0..<5) { _ in
                    CourseCard(course: PreviewObjects.course)
                        .padding()
                }
            }
        }
        .previewLayout(.sizeThatFits)
        NavigationView {
            CourseCard(course: PreviewObjects.course)
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
            
    }
}
#endif
