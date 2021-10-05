//
//  StorageManager.swift
//  Rift
//
//  Created by Varun Chitturi on 9/27/21.
//

import Foundation

protocol StorageManager {
    static var storageIdentifier: String { get }
}

extension StorageManager {
    static var storageIdentifier: String {
        return String(describing: Self.self)
    }
}
