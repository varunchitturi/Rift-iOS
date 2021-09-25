//
//  UserPreference.swift
//  UserPreference
//
//  Created by Varun Chitturi on 9/23/21.
//

import Foundation

struct UserPreference: Identifiable {
    
    init(label: String, preferenceType: UserPreference.PreferenceType, preferenceGroup: UserPreference.PreferenceGroup, prominence: UserPreference.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), linkedPreferences: [UserPreference.PreferenceGroup: [UserPreference]]? = nil) {
        self.label = label
        self.preferenceType = preferenceType
        self.preferenceGroup = preferenceGroup
        self.icon = icon
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = linkedPreferences
    }
    
    let label: String
    let preferenceType: PreferenceType
    let preferenceGroup: PreferenceGroup
    let prominence: Prominence
    let icon: String?
    let action: (Any?) -> ()
    let linkedPreferences: [UserPreference.PreferenceGroup: [UserPreference]]?
    
    var id: Int {
        label.hashValue
    }
    
    enum PreferenceType {
        case toggle, link, button
    }
    enum PreferenceGroup: String, CaseIterable, Identifiable {
        var id: Int {
            self.rawValue.hashValue
        }
        case user = "User", courses = "Courses", notifications = "Notifications"
    }
    
    enum Prominence {
        case high, low
    }
}
