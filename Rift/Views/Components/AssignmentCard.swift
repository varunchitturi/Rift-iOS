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
                    .foregroundColor(DrawingConstants.foregroundColor)
                if assignment.categoryName != nil {
                    TextTag(assignment.categoryName!)
                        .padding(.top, 0.5)
                }
                
                Text(assignment.courseName)
                    .fontWeight(.semibold)
                    .font(.caption)
                    .foregroundColor(DrawingConstants.secondaryForegroundColor)
                    .padding([.vertical], DrawingConstants.textInsetPadding)
            }
            .lineLimit(1)
            .padding(DrawingConstants.textPadding)
            Spacer()
            CircleBadge(assignment.totalPoints?.description)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(DrawingConstants.backgroundColor)
        )
        
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let backgroundColor = Color("Secondary")
        static let backgroundCornerRadius: CGFloat = 15
        static let secondaryForegroundColor = Color("Quartenary")
        static let textPadding: CGFloat = 11
        static let textInsetPadding: CGFloat = 1.5
    }
}

struct AssignmentCard_Previews: PreviewProvider {
    static var previews: some View {
        
        AssignmentCard(assignment: PreviewObjects.assignment)
            
    }
}
