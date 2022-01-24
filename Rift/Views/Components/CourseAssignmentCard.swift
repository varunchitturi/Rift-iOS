//
//  CourseAssignmentCard.swift
//  Rift
//
//  Created by Varun Chitturi on 10/6/21.
//

import SwiftUI

struct CourseAssignmentCard: View {
    let assignment: Assignment
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                Text(assignment.assignmentName)
                    .foregroundColor(Rift.DrawingConstants.foregroundColor)
                if assignment.categoryName != nil {
                    TextTag(assignment.categoryName!)
                        .padding(.top, DrawingConstants.textInsetPadding)
                }
            }
            .lineLimit(1)
            .padding(.horizontal, DrawingConstants.textHorizontalPadding)
            .padding(.vertical, DrawingConstants.textVerticalPadding)
            Spacer()
            CardAssignmentGrade(assignment: assignment)
            Image(systemName: "chevron.right")
                .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                .font(.callout.bold())
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(Rift.DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
        
    }
    
    private enum DrawingConstants {
        static let backgroundCornerRadius: CGFloat = 15
        static let textHorizontalPadding: CGFloat = 11
        static let textVerticalPadding: CGFloat = 16
        static let textInsetPadding: CGFloat = 5
        static let scoreDividerWidth: CGFloat = 1.5
        static let scoreDividerPadding: CGFloat = 20
    }
}

#if DEBUG
struct CourseAssignmentCard_Previews: PreviewProvider {
    static var previews: some View {
        CourseAssignmentCard(assignment: PreviewObjects.assignment)
    }
}
#endif
