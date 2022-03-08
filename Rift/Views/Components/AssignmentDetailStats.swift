//
//  AssignmentDetailStats.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import SwiftUI

/// A view to present details about an `Assignment`
struct AssignmentDetailStats: View {
    
    init(dueDate: Date?, assignedDate: Date?, realPercentage: Double?, calculatedPercentage: Double?) {
        self.dueDate = dueDate
        self.assignedDate = assignedDate
        self.realPercentage = realPercentage
        self.calculatedPercentage = calculatedPercentage
    }
    
    
    let dueDate: Date?
    let assignedDate: Date?
    let realPercentage: Double?
    let calculatedPercentage: Double?
    
    private var percentageDisplayColor: Color {
        if let realPercentage = realPercentage,
           let calculatedPercentage = calculatedPercentage {
            if realPercentage > calculatedPercentage {
                return Color.red
            }
            else if realPercentage < calculatedPercentage {
                return Color.green
            }
        }
        return Rift.DrawingConstants.foregroundColor
    }
    
    var body: some View {
        HStack {
            AssignmentStat(title: "Due Date", display: String(displaying: dueDate, formatter: .simple))
            Spacer()
            AssignmentStat(title: "Assigned Date", display: String(displaying: assignedDate, formatter: .simple))
            Spacer()
            AssignmentStat(title: "Percentage", display: String(displaying: calculatedPercentage, style: .percentage, truncatedTo: Rift.DrawingConstants.decimalCutoff), displayColor: percentageDisplayColor)
        }
        .foregroundColor(Rift.DrawingConstants.foregroundColor)
    }
    private enum DrawingConstants {
        static let headerPadding: CGFloat = 5
    }
    
    private struct AssignmentStat: View {
        
        init(title: String, display: String, displayColor: Color = Rift.DrawingConstants.foregroundColor) {
            self.title = title
            self.display = display
            self.displayColor = displayColor
        }
        
        let title: String
        let display: String
        let displayColor: Color
        
        var body: some View {
            VStack {
                Group {
                    Text(title)
                        .font(.caption.bold())
                        .foregroundColor(Rift.DrawingConstants.accentColor)
                        .padding(.bottom, DrawingConstants.headerPadding)
                    Text(display)
                        .foregroundColor(displayColor)
                        .font(.callout)
                }
                .lineLimit(1)
            }
        }
    }
}

#if DEBUG
struct AssignmentDetailStats_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailStats(dueDate: Date.now, assignedDate: Date.now, realPercentage: 100, calculatedPercentage: 100)
    }
}
#endif
