//
//  CourseDetailStatsRow.swift
//  Rift
//
//  Created by Varun Chitturi on 10/9/21.
//

import SwiftUI

struct CourseDetailStatsRow: View {
    let category: String
    let realGrade: Double?
    let calculatedGrade: Double?
    
    private var gradeChangeColor: Color {
        guard let realGrade = realGrade?.truncated(Rift.DrawingConstants.decimalCutoff),
              let calculatedGrade = calculatedGrade?.truncated(Rift.DrawingConstants.decimalCutoff) else {
            return Rift.DrawingConstants.foregroundColor
        }
        
        print(realGrade)
        print(calculatedGrade)
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
                Group {
                    Text(String(displaying: calculatedGrade, style: .percentage, truncatedTo: Rift.DrawingConstants.decimalCutoff))
                }
                .foregroundColor(gradeChangeColor)
                .multilineTextAlignment(.center)
                
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
