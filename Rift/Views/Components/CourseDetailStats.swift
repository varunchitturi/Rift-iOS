//
//  CourseDetailStats.swift
//  Rift
//
//  Created by Varun Chitturi on 10/7/21.
//

import SwiftUI

struct CourseDetailStats: View {
    // TODO: make sure that the preview objects file doesn't compile on release
    var courseGradeDisplay: String
    let gradeDetail: GradeDetail
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Group {
                        Text("Grade")
                            .offset(x: DrawingConstants.gradeXAdjustment)
                        Text("Category")
                    }
                    .frame(width: DrawingConstants.tableCellWidth, alignment: .leading)
                    
                    Spacer()
                    
                    Group {
                        Text("Real")
                        Text("Calculated")
                        
                    }
                    .frame(width: DrawingConstants.tableCellWidth, alignment: .leading)
                }
                .foregroundColor(DrawingConstants.headerForegroundColor)
                .font(.caption.bold())
                HStack {
                    VStack {
                        CircleBadge(courseGradeDisplay, size: .large)
                            .frame(width: DrawingConstants.tableCellWidth, alignment: .leading)
                        
                    }
                    VStack (alignment: .leading, spacing: DrawingConstants.rowSpacing) {
                        ForEach(gradeDetail.categories){ gradingCategory in
                            CourseDetailStatsRow(category: gradingCategory.name, realGrade: gradingCategory.percentageDisplay, calculatedGrade:  gradingCategory.percentageDisplay)
                        }
                        CourseDetailStatsRow(category: "Total", realGrade: gradeDetail.totalPercentageDisplay, calculatedGrade:  gradeDetail.totalPercentageDisplay)
                        
                    }
                }
                .foregroundColor(DrawingConstants.foregroundColor)
            }
        }
        .font(.caption)
    }

    private struct DrawingConstants {
        static let tableCellWidth: CGFloat = 70
        static let rowSpacing: CGFloat = 10
        static let gradeXAdjustment = 0.01 * UIScreen.main.bounds.width
        static let headerForegroundColor = Color("Primary")
        static let foregroundColor = Color("Tertiary")
    }
}

struct GradeDetailStatView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailStats(courseGradeDisplay: PreviewObjects.course.gradeDisplay, gradeDetail: PreviewObjects.gradeDetail)
        CourseDetailStats(courseGradeDisplay: PreviewObjects.course.gradeDisplay, gradeDetail: PreviewObjects.gradeDetail)
            .previewDevice("iPhone 13 Pro Max")
    }
}
