//
//  CourseDetailStatsRow.swift
//  Rift
//
//  Created by Varun Chitturi on 10/9/21.
//

import SwiftUI

struct CourseDetailStatsRow: View {
    let category: String
    let realGrade: String
    let calculatedGrade: String
    
    var body: some View {
        HStack {
            TextTag(category)
            
            Spacer()
            
            Group {
                Text(calculatedGrade)
                Text(realGrade)
            }
            .frame(width: DrawingConstants.tableCellWidth, alignment: .leading)
        }
    }
    
    private struct DrawingConstants {
        static let tableCellWidth: CGFloat = 70
    }
}

struct CourseDetailStatsRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailStatsRow(category: "Test", realGrade: "90%", calculatedGrade: "100%")
    }
}
