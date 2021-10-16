//
//  AssignmentDetailStats.swift
//  Rift
//
//  Created by Varun Chitturi on 10/13/21.
//

import SwiftUI

struct AssignmentDetailStats: View {
    // TODO: add line limit to course detail stats
    @EnvironmentObject var assignmentDetailViewModel: AssignmentDetailViewModel
    var body: some View {
        HStack {
            let statsDisplays = assignmentDetailViewModel.statsDisplays
            ForEach (statsDisplays.indices) { index in
                VStack {
                    Text(statsDisplays[index].header)
                        .font(.caption2.bold())
                        .foregroundColor(DrawingConstants.headerColor)
                        .padding(.bottom, DrawingConstants.headerPadding)
                    Text(statsDisplays[index].text)
                        .font(.caption2)
                }
                let endIndex = statsDisplays.endIndex
                if index != statsDisplays.index(before: endIndex) {
                    Spacer()
                }
            }
        }
        .foregroundColor(DrawingConstants.foregroundColor)
    }
    private struct DrawingConstants {
        static let headerPadding: CGFloat = 5
        static let headerColor = Color("Primary")
        static let foregroundColor = Color("Tertiary")
    }
}

struct AssignmentDetailStats_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailStats()
            .environmentObject(AssignmentDetailViewModel(originalAssignment: PreviewObjects.assignment, assignmentToEdit: .constant(PreviewObjects.assignment), gradingCategories: [PreviewObjects.gradingCategory]))
    }
}
