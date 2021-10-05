//
//  CoreDataUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 10/2/21.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private static let persistentContainerName = "Model"
    
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: PersistenceController.persistentContainerName)
        

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores {[container] description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
            else {
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            }
        }
    }
    
    func save() throws {
        let context = container.viewContext

        if context.hasChanges {
            try context.save()
        }
    }
}
