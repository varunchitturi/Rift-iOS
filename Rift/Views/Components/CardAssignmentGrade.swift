//
//  CardAssignmentGrade.swift
//  Rift
//
//  Created by Varun Chitturi on 12/7/21.
//

import SwiftUI

struct CardAssignmentGrade: View {
    let assignment: Assignment
    var body: some View {
        HStack {
            CircleBadge(assignment.scorePointsDisplay, style: .secondary)
            Capsule()
                .frame(width: DrawingConstants.scoreDividerWidth)
                .foregroundColor(DrawingConstants.scoreDividerColor)
                .padding(.vertical, DrawingConstants.scoreDividerPadding)
            CircleBadge(assignment.totalPointsDisplay)
        }
    }
    private struct DrawingConstants {
        static let scoreDividerWidth: CGFloat = 1.5
        static let scoreDividerPadding: CGFloat = 20
        static let scoreDividerColor = Color("Background")
    }
}

#if DEBUG
struct CardAssignmentGrade_Previews: PreviewProvider {
    static var previews: some View {
        CardAssignmentGrade(assignment: PreviewObjects.assignment)
    }
}
#endif
