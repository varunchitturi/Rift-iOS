//
//  HomeView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct HomeView: View {
    @State private var tab: TabBar.Tab = .courses
    @ObservedObject var coursesViewModel: CoursesViewModel
    @ObservedObject var plannerViewModel: PlannerViewModel
    // TODO: display header in home view naviagtion such as name + assignment information
    let locale: Locale
    
    init(locale: Locale) {
        self.locale = locale
        coursesViewModel = CoursesViewModel(locale: locale)
        plannerViewModel = PlannerViewModel(locale: locale)
    }

    var body: some View {
        VStack {
            switch tab {
            case .courses:
                // Try to cache the json from network request or not have to create view each time
                CoursesView(viewModel: coursesViewModel)
            case .planner:
                PlannerView(viewModel: plannerViewModel)
            case .inbox:
                Text("Inbox")
            }
            Spacer()
            TabBar(selected: $tab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locale: PreviewObjects.locale)
    }
}
