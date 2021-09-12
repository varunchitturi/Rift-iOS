//
//  HomeView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import SwiftUI

struct HomeView: View {
    @State private var tab: TabBar.Tab = .courses
    let locale: Locale
    var body: some View {
        VStack {
            switch tab {
            case .courses:
                CoursesView(locale: locale)
            case .planner:
                Text("Planner")
            case .inbox:
                Text("Inbox")
            }
            Spacer()
            TabBar(selected: $tab)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locale: PreviewObjects.locale)
    }
}
