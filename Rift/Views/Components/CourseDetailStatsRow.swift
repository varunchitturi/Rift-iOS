//
//  CourseDetailStatsRow.swift
//  Rift
//
//  Created by Varun Chitturi on 10/9/21.
//

import SwiftUI

struct CourseDetailStatsRow: View {
    
    internal init(category: String, realGrade: Double?, calculatedGrade: Double?, isProminent: Bool = false) {
        self.category = category
        self.realGrade = realGrade
        self.calculatedGrade = calculatedGrade
        self.isProminent = isProminent
    }
    
    let category: String
    let realGrade: Double?
    let calculatedGrade: Double?
    let isProminent: Bool
    
    private var gradeChangeColor: Color {
        guard let realGrade = realGrade?.truncated(Rift.DrawingConstants.decimalCutoff),
              let calculatedGrade = calculatedGrade?.truncated(Rift.DrawingConstants.decimalCutoff) else {
            return Rift.DrawingConstants.foregroundColor
        }
    
        if calculatedGrade < realGrade {
            return Color.red
        }
        else if calculatedGrade > realGrade{
            return Color.green
        }
        return Rift.DrawingConstants.foregroundColor
    }
    
    var body: some View {
        VStack {
            HStack {
                TextTag(category)
                Spacer()
                Text(String(displaying: calculatedGrade, style: .percentage, truncatedTo: Rift.DrawingConstants.decimalCutoff))
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
        CourseDetailStatsRow(category: "Test", realGrade: 90, calculatedGrade: 100)
    }
}
#endif
