//
//  CourseDetailStats.swift
//  Rift
//
//  Created by Varun Chitturi on 10/7/21.
//

import SwiftUI

/// A view to display all grade stats in the `CourseDetailView`
struct CourseDetailStats: View {
    // TODO: make sure that the preview objects file doesn't compile on release
    // TODO: check if percentages are rounded or truncated
    @State private var detailIsPresented = false
    let gradeDetail: GradeDetail
    let editingGradeDetail: GradeDetail
    let showCalculatedGrade: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Category")
                        Spacer()
                        Text("Percentage")
                    }
                    .lineLimit(1)
                    .foregroundColor(Rift.DrawingConstants.accentColor)
                    .font(.callout.bold())
                    Divider()
                    CourseDetailStatsRow(category: "Total", realGrade: gradeDetail.totalPercentage, calculatedGrade: editingGradeDetail.totalPercentage, showCalculated: showCalculatedGrade, isProminent: true)
                }
                HStack {
                    VStack (alignment: .leading, spacing: DrawingConstants.rowSpacing) {
                        let categories = editingGradeDetail.categories
                        ForEach(categories.indices, id: \.self) { index in
                            CourseDetailStatsRow(
                                category: categories[index].name,
                                realGrade: categories[index].categoryGrade?.percentage,
                                calculatedGrade: categories[index].percentage,
                                showCalculated: showCalculatedGrade
                            )
                        }
                    }
                }
                if gradeDetail.totalPercentage?.truncated(Rift.DrawingConstants.decimalCutoff) != editingGradeDetail.totalPercentage?.truncated(Rift.DrawingConstants.decimalCutoff) &&
                    gradeDetail.assignments == editingGradeDetail.assignments {
                    Text("The real and calculated grade are different because of an inconsistency in Infinite Campus.")
                        .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                        .font(.caption2)
                }
            }
        }
    }

    private enum DrawingConstants {
        static let tableCellWidth: CGFloat = 70
        static let rowSpacing: CGFloat = 10
        static let gradeXAdjustment = 0.01 * UIScreen.main.bounds.width
    }
}

#if DEBUG
struct GradeDetailStatView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailStats(gradeDetail: PreviewObjects.gradeDetail, editingGradeDetail: PreviewObjects.gradeDetail, showCalculatedGrade: true)
            .padding()
        CourseDetailStats(gradeDetail: PreviewObjects.gradeDetail, editingGradeDetail: PreviewObjects.gradeDetail, showCalculatedGrade: true)
            .previewDevice("iPhone 13 Pro Max")
    }
}
#endif
