//
//  RiftApp.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
//

import SwiftUI
import Firebase

@main
struct RiftApp: App {

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        // TODO: Change status bar color
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    
}
