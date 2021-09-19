//
//  PlannerView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct PlannerView: View {
    @ObservedObject var plannerViewModel: PlannerViewModel
    init(viewModel: PlannerViewModel) {
        plannerViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                let dates = plannerViewModel.dates
                let assignmentDateList = plannerViewModel.assignmentDateList
                ForEach(dates, id: \.hashValue) {date in
                    Section(header: SectionHeader (date != nil ? PlannerViewModel.dateFormatter.string(from: date!) : "No Due Date")) {
                        ForEach(assignmentDateList[date]!) { assignment in
                            PlannerCard(assignment: assignment)
                        }
                    }
                    .foregroundColor(DrawingConstants.foregroundColor)
                }
            }
            .navigationTitle(TabBar.Tab.planner.rawValue)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
    }
}
