//
//  CourseDetailStats.swift
//  Rift
//
//  Created by Varun Chitturi on 10/7/21.
//

import SwiftUI

struct CourseDetailStats: View {
    // TODO: make sure that the preview objects file doesn't compile on release
    // TODO: check if percentages are rounded or truncated
    var courseGradeDisplay: String
    let gradeDetail: GradeDetail
    let editingGradeDetail: GradeDetail
    
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
                .foregroundColor(Rift.DrawingConstants.accentColor)
                .font(.caption.bold())
                
                HStack {
                    VStack {
                        CircleBadge(courseGradeDisplay, size: .large)
                            .frame(width: DrawingConstants.tableCellWidth, alignment: .leading)
                        
                    }
                    VStack (alignment: .leading, spacing: DrawingConstants.rowSpacing) {
                        let categories = gradeDetail.categories
                        let editingCategories = editingGradeDetail.categories
                        ForEach(gradeDetail.categories.indices, id: \.self){ index in
                            CourseDetailStatsRow(category: categories[index].name, realGrade: categories[index].percentageDisplay, calculatedGrade:  editingCategories[index].percentageDisplay)
                        }
                        CourseDetailStatsRow(category: "Total", realGrade: gradeDetail.totalPercentageDisplay, calculatedGrade:  editingGradeDetail.totalPercentageDisplay)
                    }
                }
            }
        }
    }

    private struct DrawingConstants {
        static let tableCellWidth: CGFloat = 70
        static let rowSpacing: CGFloat = 10
        static let gradeXAdjustment = 0.01 * UIScreen.main.bounds.width
    }
}

#if DEBUG
struct GradeDetailStatView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailStats(courseGradeDisplay: PreviewObjects.course.gradeDisplay, gradeDetail: PreviewObjects.gradeDetail, editingGradeDetail: PreviewObjects.gradeDetail)
        CourseDetailStats(courseGradeDisplay: PreviewObjects.course.gradeDisplay, gradeDetail: PreviewObjects.gradeDetail, editingGradeDetail: PreviewObjects.gradeDetail)
            .previewDevice("iPhone 13 Pro Max")
    }
}
#endif
