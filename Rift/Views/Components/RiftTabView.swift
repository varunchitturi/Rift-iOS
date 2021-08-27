//
//  RiftTabBar.swift
//  Rift
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct RiftTabView: View {
    var body: some View {
        TabView(selection: .constant(1)) {
            Text("Tab Content 1").tabItem {
                VStack {
                    Image(systemName: "pencil")
                    Text("Courses")
                }
                
            }
            .tag("Courses")
            Text("Tab Content 2").tabItem {
                VStack {
                    Image(systemName: "book")
                    Text("Planner")
                }
                
                
            }
            .tag("Planner")
            Text("Tab Content 1").tabItem {
                VStack {
                    Image(systemName: "tray")
                    Text("Inbox")
                }
                
            }
            .tag("Messages")
        }
        
        
    }
}

struct RiftTabView_Previews: PreviewProvider {
    static var previews: some View {
        RiftTabView()
    }
}
