//
//  HomeView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct HomeView: View {
    @State private var tab: TabBar.Tab = .courses
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var coursesViewModel: CoursesViewModel
    @ObservedObject var plannerViewModel: PlannerViewModel
    
    // TODO: display header in home view naviagtion such as name + assignment information
    
    init(locale: Locale) {
        coursesViewModel = CoursesViewModel(locale: locale)
        plannerViewModel = PlannerViewModel(locale: locale)
        homeViewModel = HomeViewModel(locale: locale)
    }

    var body: some View {
        VStack {
            switch tab {
            case .courses:
                // Try to cache the json from network request or not have to create view each time
                CoursesView(viewModel: coursesViewModel)
                    .environmentObject(homeViewModel)
            case .planner:
                PlannerView(viewModel: plannerViewModel)
                    .environmentObject(homeViewModel)
            case .inbox:
                Text("Inbox")
            }
            
        }
        .overlay(TabBar(selected: $tab)
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.horizontal),
                 alignment: .bottom
        )
        .sheet(isPresented: $homeViewModel.settingsIsPresented) {
            UserPreferenceView(preferences: UserPreference.shared)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locale: PreviewObjects.locale)
    }
}
