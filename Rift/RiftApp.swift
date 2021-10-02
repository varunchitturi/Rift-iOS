//
//  RiftApp.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
//

import SwiftUI

@main
struct RiftApp: App {
    // TODO: add a launch screen
    // TODO: accessibility
    
    var body: some Scene {
        // TODO: Change status bar color
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    
}
