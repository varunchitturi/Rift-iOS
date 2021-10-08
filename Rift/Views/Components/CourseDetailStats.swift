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
            VStack {
                HStack(alignment: .top) {
                    
                    Text("Grade")
                        .frame(width: DrawingConstants.tableFrameSize)
                        
                    Text("Category")
                        .frame(width: DrawingConstants.tableFrameSize)
                    
                        .offset(x: UIScreen.main.bounds.width*DrawingConstants.categoryColumnAdjustmentMultiplier)
                    
                    
                    Spacer()
                    Group {
                        Text("Real")
                        Text("Calculated")
                        
                    }
                    .frame(width: DrawingConstants.tableFrameSize)
                }
                .foregroundColor(DrawingConstants.headerForegroundColor)
                .font(.caption.bold())
                HStack {
                    VStack {
                        CircleBadge(courseGradeDisplay, size: .large)
                            .frame(width: DrawingConstants.tableFrameSize)
                    }
                    VStack(spacing: DrawingConstants.rowSpacing) {
                        ForEach(gradeDetail.categories){ gradingCategory in
                            HStack {
                                TextTag(gradingCategory.name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .offset(x: UIScreen.main.bounds.width*DrawingConstants.categoryColumnAdjustmentMultiplier)
                                Group {
                                    Text(gradingCategory.percentageDisplay)
                                    Text(gradingCategory.percentageDisplay)
                                }
                                .frame(width: DrawingConstants.tableFrameSize)
                            }
                            
                        }
                    }
                }
                .foregroundColor(DrawingConstants.foregroundColor)
            }
            
            
        }
        .font(.caption)
        .padding(.trailing)
    }

    private struct DrawingConstants {
        static let tableFrameSize: CGFloat = 70
        static let rowSpacing: CGFloat = 10
        static let categoryColumnAdjustmentMultiplier = 0.03
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
