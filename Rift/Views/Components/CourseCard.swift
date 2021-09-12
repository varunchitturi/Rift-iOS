//
//  CourseCard.swift
//  CourseCard
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct CourseCard: View {
    
    init(courseName: String, teacher: String, pointsEarned: Double? = nil, totalPoints: Double? = nil, letterGrade: String? = nil) {
        if let pointsEarned = pointsEarned, let totalPoints = totalPoints, totalPoints != 0 {
            self.percentage = round((pointsEarned/totalPoints) * 10000) / 100
        }
       
        self.courseName = courseName
        self.teacher = teacher
        self.letterGrade = letterGrade
    }
    var courseName: String
    var teacher: String
    var percentage: Double?
    var letterGrade: String?
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(courseName)
                        .lineLimit(1)
                    Text(teacher)
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
                               idealWidth: DrawingConstants.idealCirlceRadius,
                               maxWidth: DrawingConstants.maxCircleRadius,
                               minHeight: DrawingConstants.maxCircleRadius,
                               idealHeight: DrawingConstants.idealCirlceRadius,
                               maxHeight: DrawingConstants.maxCircleRadius,
                               alignment: .trailing)
                        .overlay(
                            Text(letterGrade ?? "N/A")
                                .fontWeight(.semibold)
                                .scaledToFill()
                                .minimumScaleFactor(0.01)
                                .foregroundColor(DrawingConstants.circleForeground)
                                .padding(9)
                        )
                    Text((percentage?.description.appending("%") ?? "N/A"))
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
        static let idealCirlceRadius = (minCircleRadius + maxCircleRadius)/2
        static let foregroundColor = Color("Tertiary")
        static let backgroundColor = Color("Secondary")
        static let circleForeground = Color("Foreground")
        static let circleBackground = Color("Background")
        static let secondaryForegroundColor = Color("Quartenary")
    }
    
}

struct CourseCard_Previews: PreviewProvider {
    static var previews: some View {
        CourseCard(courseName: "AP Computer Science", teacher: "Mr. Brucker", pointsEarned: 90, totalPoints: 101, letterGrade: "B+")
            .padding()
            .previewLayout(.sizeThatFits) 
        CourseCard(courseName: "AP Computer Science", teacher: "Mr. Brucker", pointsEarned: 90, totalPoints: 101, letterGrade: "B+")
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            
    }
}
