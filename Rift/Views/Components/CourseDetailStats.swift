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
                    
                    Text("Grade")
                        .frame(width: DrawingConstants.tableFrameSize, alignment: .leading)
                        .offset(x: DrawingConstants.gradeXAdjustment)
                        
                    Text("Category")
                        .frame(width: DrawingConstants.tableFrameSize, alignment: .leading)
                        
                    Spacer()
                    
                    Group {
                        Text("Real")
                        Text("Calculated")
                        
                    }
                    .frame(width: DrawingConstants.tableFrameSize, alignment: .leading)
                }
                .foregroundColor(DrawingConstants.headerForegroundColor)
                .font(.caption.bold())
                HStack {
                    VStack {
                        CircleBadge(courseGradeDisplay, size: .large)
                            .frame(width: DrawingConstants.tableFrameSize, alignment: .leading)
                        
                    }
                    VStack (alignment: .leading, spacing: DrawingConstants.rowSpacing) {
                        ForEach(gradeDetail.categories){ gradingCategory in
                            HStack {
                                TextTag(gradingCategory.name)
                                
                                Spacer()
                                
                                Group {
                                    Text(gradingCategory.percentageDisplay)
                                    Text(gradingCategory.percentageDisplay)
                                }
                                .frame(width: DrawingConstants.tableFrameSize, alignment: .leading)
                            }
                        }
                    }
                }
                .foregroundColor(DrawingConstants.foregroundColor)
            }
        }
        .font(.caption)
    }

    private struct DrawingConstants {
        static let tableFrameSize: CGFloat = 70
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
