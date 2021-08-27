//
//  CourseCard.swift
//  CourseCard
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct CourseCard: View {
    
    init(courseName: String, teacher: String, percentage: Double?) {
        self.percentage = percentage
        self.courseName = courseName
        self.teacher = teacher
        
    }
    
    var courseName: String
    var teacher: String
    var percentage: Double?
    var letterGrade: String {
        if let percentage = self.percentage {
            switch percentage{
            case _ where percentage >= 90:
                return "A"
            case _ where percentage >= 80:
                return "B"
            case _ where percentage >= 70:
                return "C"
            case _ where percentage >= 60:
                return "D"
            default:
                return "F"
            }
        }
        return "N/A"
    }
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(courseName)
                        .lineLimit(1)
                    Text(teacher)
                        .foregroundColor(Color("Quartenary"))
                        .fontWeight(.semibold)
                        .font(.caption)
                        .lineLimit(1)
                }
                .padding([.bottom], 0)
                Spacer()
                VStack {
                    Circle()
                        .fill(Color("Background"))
                        .frame(minWidth: DrawingConstants.minCircleRadius, idealWidth: DrawingConstants.idealCirlceRadius, maxWidth: DrawingConstants.maxCircleRadius, minHeight: DrawingConstants.maxCircleRadius, idealHeight: DrawingConstants.idealCirlceRadius, maxHeight: DrawingConstants.maxCircleRadius, alignment: .trailing)
                        .overlay(
                            Text(letterGrade)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .scaledToFill()
                                .minimumScaleFactor(0.01)
                                .foregroundColor(Color("Foreground"))
                        )
                    Text((percentage?.description ?? "N/A") + "%")
                        .lineLimit(1)
                        .font(.caption)
                        .frame(width: 80)
                    
                }
            }
            .foregroundColor(Color("Tertiary"))
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("Secondary"))
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private struct DrawingConstants {
        static let circleBackground = Color(red: 10, green: 10, blue: 10)
        static let circleForeground = Color(red: 10, green: 10, blue: 10)
        static let minCircleRadius: CGFloat = 30.0
        static let maxCircleRadius: CGFloat = 35.0
        static let idealCirlceRadius = minCircleRadius / maxCircleRadius
    }
    
}

struct CourseCard_Previews: PreviewProvider {
    static var previews: some View {
        CourseCard(courseName: "AP Computer Science", teacher: "Mr. Brucker", percentage: 100.32)
            .preferredColorScheme(.dark)
            .padding()
            
    }
}
