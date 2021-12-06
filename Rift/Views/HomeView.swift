//
//  HomeView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject var coursesViewModel: CoursesViewModel = CoursesViewModel()
    @StateObject var assignmentsViewModel: AssignmentsViewModel = AssignmentsViewModel()
    @StateObject var inboxViewModel: InboxViewModel = InboxViewModel()
    
    // TODO: display header in home view naviagtion such as name + assignment information

    var body: some View {
        TabView {
            CoursesView(viewModel: coursesViewModel)
                .environmentObject(homeViewModel)
                .tabItem {
                    HomeModel.Tab.courses
                }
            
            AssignmentsView(viewModel: assignmentsViewModel)
                .environmentObject(homeViewModel)
                .tabItem {
                    HomeModel.Tab.assignments
                }
            
            InboxView(viewModel: inboxViewModel)
                .environmentObject(homeViewModel)
                .tabItem {
                    HomeModel.Tab.inbox
                }
        }
        
        .sheet(isPresented: $homeViewModel.settingsIsPresented) {
            UserPreferenceView(preferences: UserPreferenceModel.shared)
                .environmentObject(homeViewModel)
        }
        
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
