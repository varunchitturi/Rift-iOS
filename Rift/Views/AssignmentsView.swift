//
//  AssignmentsView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct AssignmentsView: View {
    @ObservedObject var assignmentsViewModel: AssignmentsViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    init(viewModel: AssignmentsViewModel) {
        assignmentsViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
                List {
                    let dates = assignmentsViewModel.dates
                    let assignmentDateList = assignmentsViewModel.assignmentDateList
                    ForEach(dates, id: \.hashValue) {date in
                        Section(header: Text(date != nil ? String(displaying: date, formatter: .naturalFull) : "No Due Date")) {
                            ForEach(assignmentDateList[date]!) { `assignment` in
                                AssignmentCard(assignment: `assignment`)
                            }

                        }
                        .textCase(nil)
                        .foregroundColor(Rift.DrawingConstants.foregroundColor)
                    }
                }
                .apiHandler(asyncState: assignmentsViewModel.networkState) {
                    AssignmentsLoadingView()
                } retryAction: { _ in
                    assignmentsViewModel.fetchAssignments()
                }
                .listStyle(.plain)
                .navigationTitle(HomeModel.Tab.assignments.label)
                .toolbar {
                    ToolbarItem(id: UUID().uuidString) {
                        UserPreferencesSheetToggle()
                            .environmentObject(homeViewModel)
                    }
                }
                
        }
        .navigationViewStyle(.stack)
        .logViewAnlaytics(self)
    }
}

private struct AssignmentsLoadingView: View {
    var body: some View {
        List {
            Section(header: Text(String.nilDisplay)) {
                ForEach(0..<DrawingConstants.placeholderCardCount) { _ in
                    AssignmentCard()
                }
            }
            .skeletonLoad()
        }
    }
    
    private enum DrawingConstants {
        static let placeholderCardCount = 8
    }
}

#if DEBUG
struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView(viewModel: AssignmentsViewModel())
            .environmentObject(HomeViewModel())
    }
}
#endif

