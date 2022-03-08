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
        WindowGroup {
            ContentView()
                // Introduce the persistent storage context as an environment variable
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    
}
