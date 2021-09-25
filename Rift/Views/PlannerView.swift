//
//  PlannerView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct PlannerView: View {
    @ObservedObject var plannerViewModel: PlannerViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    // TODO: add more space for scroll so tab bar doesn't hide certain assignments
    // TODO: change colors to match courses
    init(viewModel: PlannerViewModel) {
        plannerViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
                List {
                    let dates = plannerViewModel.dates
                    let assignmentDateList = plannerViewModel.assignmentDateList
                    ForEach(dates, id: \.hashValue) {date in
                        Section(header: Text(date != nil ? PlannerViewModel.dateFormatter.string(from: date!) : "No Due Date")) {
                            ForEach(assignmentDateList[date]!) { assignment in
                                PlannerCard(assignment: assignment)
                                    .listRowSeparator(.hidden)
                            }
                            
                        }
                        .textCase(nil)
                        .foregroundColor(DrawingConstants.foregroundColor)
                    }
                    
                    TabBar.Clearance()
                    
                }
                .listStyle(.plain)
               
                .navigationTitle(TabBar.Tab.planner.label)
                .toolbar {
                    ToolbarItem(id: UUID().uuidString) {
                        UserPreferencesButton()
                            .environmentObject(homeViewModel)
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let backgroundColor = Color("Secondary")
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView(viewModel: PlannerViewModel(locale: PreviewObjects.locale))
            .environmentObject(HomeViewModel(locale: PreviewObjects.locale))
    }
}
