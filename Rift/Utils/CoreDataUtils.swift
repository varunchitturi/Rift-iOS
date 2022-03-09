//
//  CoreDataUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 10/2/21.
//

import Foundation
import CoreData

struct PersistenceController {
    
    /// The default persistence controller to use for Core Data
    static let shared = PersistenceController()
    
    /// A  container for persistent data storage
    let container: NSPersistentContainer
    
    /// The default name for a persistent container
    private static let persistentContainerName = "Model"
    
    /// Creates a persistent store
    /// - Parameter inMemory: Choose whether the data should be saved to a file in memory
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: PersistenceController.persistentContainerName)
        

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores {[weak container] description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
            else {
                container?.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            }
        }
    }
    
    /// Saves the current container context to the store
    /// - Use this whenever you want too save any changes in a `viewContext` to memory
    func save() throws {
        let context = container.viewContext

        if context.hasChanges {
            try context.save()
        }
    }
}
