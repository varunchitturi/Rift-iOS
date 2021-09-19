//
//  PlannerCard.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct PlannerCard: View {
    let assignment: Planner.Assignment
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Group {
                    Text(assignment.assignmentName)
                        .foregroundColor(DrawingConstants.foregroundColor)
                    Text(assignment.courseName)
                        .fontWeight(.semibold)
                        .font(.caption)
                        .foregroundColor(DrawingConstants.secondaryForegroundColor)
                }
                .padding([.vertical], DrawingConstants.textInsetPadding)
            }
            .lineLimit(1)
            .padding(DrawingConstants.textPadding)
            Spacer()
            CircleBadge(assignment.totalPoints?.description)
        }
        .padding(.horizontal)
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let secondaryForegroundColor = Color("Quartenary")
        static let textPadding: CGFloat = 5
        static let textInsetPadding: CGFloat = 1.5
        
    }
}

struct PlannerCard_Previews: PreviewProvider {
    static var previews: some View {
        PlannerCard(assignment: PreviewObjects.assignment)
    }
}
