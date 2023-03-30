//
//  PersistentLocaleTransformationPolicy.swift
//  Rift
//
//  Created by Varun Chitturi on 3/30/23.
//

import Foundation
import CoreData

class MigrationPolicyV1_to_V2: NSEntityMigrationPolicy {
    
    
    
    func persistentLocaleIdV2Transformation(for id: NSNumber) -> NSString {
        return NSString(string: id.stringValue)
    }
}
