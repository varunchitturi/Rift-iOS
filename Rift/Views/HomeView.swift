//
//  HomeView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct HomeView: View {
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
        TabView {
            CoursesView(viewModel: coursesViewModel)
                .environmentObject(homeViewModel)
                .tabItem {
                    Home.Tab.courses
                }
            
            PlannerView(viewModel: plannerViewModel)
                .environmentObject(homeViewModel)
                .tabItem {
                    Home.Tab.planner
                }
            
            Text("Inbox")
                .tabItem {
                    Home.Tab.inbox
                }
        }
        .tabViewStyle(backgroundColor: Color(UIColor.systemBackground), unselectedColor: Color("Quartenary"))
        .sheet(isPresented: $homeViewModel.settingsIsPresented) {
            UserPreferenceView(preferences: UserPreference.shared)
                .environmentObject(homeViewModel)
        }
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locale: PreviewObjects.locale)
    }
}
