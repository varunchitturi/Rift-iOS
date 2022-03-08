//
//  CardAssignmentGrade.swift
//  Rift
//
//  Created by Varun Chitturi on 12/7/21.
//

import SwiftUI

/// A view to show a fraction-based score on an assignment
/// - Shows 2 numbers separated by a vertical divider
struct CardAssignmentGrade: View {
    
    init(assignment: Assignment? = nil) {
        self.assignment = assignment
    }
    
    let assignment: Assignment?
    var body: some View {
        HStack {
            CircleBadge(String(displaying: assignment?.scorePoints), style: .secondary)
            Capsule()
                .fill(Rift.DrawingConstants.accentBackgroundColor)
                .frame(width: DrawingConstants.scoreDividerWidth)
                .padding(.vertical, DrawingConstants.scoreDividerPadding)
            CircleBadge(String(displaying: assignment?.totalPoints))
        }
    }
    private enum DrawingConstants {
        static let scoreDividerWidth: CGFloat = 1.5
        static let scoreDividerPadding: CGFloat = 20
    }
}

#if DEBUG
struct CardAssignmentGrade_Previews: PreviewProvider {
    static var previews: some View {
        CardAssignmentGrade(assignment: PreviewObjects.assignment)
    }
}
#endif
