//
//  AssignmentCard.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct AssignmentCard: View {
    let assignment: Assignment
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                Text(assignment.assignmentName)
                    .foregroundColor(Rift.DrawingConstants.foregroundColor)
                
                Text(assignment.courseName)
                    .fontWeight(.semibold)
                    .font(.caption)
                    .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                    .padding([.vertical], DrawingConstants.textInsetPadding)
            }
            .lineLimit(1)
            .padding(DrawingConstants.textPadding)
            Spacer()
            CardAssignmentGrade(assignment: assignment)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(Rift.DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private struct DrawingConstants {
        static let backgroundCornerRadius: CGFloat = 15
        static let textPadding: CGFloat = 11
        static let textInsetPadding: CGFloat = 1.5
    }
}

#if DEBUG
struct AssignmentCard_Previews: PreviewProvider {
    static var previews: some View {
        
        AssignmentCard(assignment: PreviewObjects.assignment)
            
    }
}
#endif
