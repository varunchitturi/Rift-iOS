//
//  BundleUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 9/25/21.
//

import Foundation

extension Bundle {
    
    /// The display name of the app bundle
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    /// The version of the app bundle
    var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}
