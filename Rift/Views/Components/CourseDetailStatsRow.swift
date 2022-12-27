//
//  CourseDetailStatsRow.swift
//  Rift
//
//  Created by Varun Chitturi on 10/9/21.
//

import SwiftUI

/// A single row in the `CourseDetailStats` view
struct CourseDetailStatsRow: View {
    
    init(category: String, realGrade: Double?, calculatedGrade: Double?, showCalculated: Bool, isProminent: Bool = false) {
        self.category = category
        self.realGrade = realGrade
        self.calculatedGrade = calculatedGrade
        self.showCalculated = showCalculated
        self.isProminent = isProminent
    }
    
    let category: String
    let realGrade: Double?
    let calculatedGrade: Double?
    let showCalculated: Bool
    let isProminent: Bool
    
    private var gradeChangeColor: Color {
        guard let realGrade = realGrade?.truncated(Rift.DrawingConstants.decimalCutoff),
              let calculatedGrade = calculatedGrade?.truncated(Rift.DrawingConstants.decimalCutoff),
                showCalculated else {
            return Rift.DrawingConstants.foregroundColor
        }
    
        if calculatedGrade < realGrade {
            return Color.red
        }
        else if calculatedGrade > realGrade {
            return Color.green
        }
        return Rift.DrawingConstants.foregroundColor
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(category)
                    .font(isProminent ? .callout.bold() : .footnote.bold())
                    .lineLimit(1)
                    .foregroundColor(Rift.DrawingConstants.accentColor)
                Spacer()
                Text(String(displaying: showCalculated ? calculatedGrade : realGrade, style: .percentage, truncatedTo: Rift.DrawingConstants.decimalCutoff))
                    .lineLimit(1)
                    .foregroundColor(gradeChangeColor)
                    .multilineTextAlignment(.center)
                    .font(isProminent ? .body : .callout)
            }
            Divider()
        }
        
    }
    
    private enum DrawingConstants {
        static let tableCellWidth: CGFloat = 70
    }
}

#if DEBUG
struct CourseDetailStatsRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailStatsRow(category: "Test", realGrade: 90, calculatedGrade: 100, showCalculated: true)
    }
}
#endif
