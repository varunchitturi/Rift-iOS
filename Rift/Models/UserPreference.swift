//
//  UserPreference.swift
//  UserPreference
//
//  Created by Varun Chitturi on 9/23/21.
//

import Foundation

struct UserPreference: Identifiable {
    
    // TODO: switch to protocol based inheritance
    // TODO: label this the toggle initializer
    init(label: String, getInitialState: @escaping () -> Bool, preferenceGroup: PreferenceGroup, prominence: UserPreference.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), configuration: () -> () = {}) {
        configuration()
        self.label = label
        self.preferenceType = .toggle
        self.preferenceGroup = preferenceGroup
        self.icon = icon
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = nil
        self.getInitialState = getInitialState
    }
    
    // TODO: label this the button initializer
    init(label: String, preferenceGroup: PreferenceGroup, prominence: UserPreference.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), configuration: () -> () = {}) {
        configuration()
        self.label = label
        self.preferenceType = .button
        self.preferenceGroup = preferenceGroup
        self.icon = icon
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = nil
        self.getInitialState = nil
    }

    // TODO: label this the link initializer
    
    init(label: String, preferenceGroup: PreferenceGroup, prominence: UserPreference.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), linkedPreferences: [UserPreference.PreferenceGroup: [UserPreference]], configuration: () -> () = {}) {
        configuration()
        self.label = label
        self.preferenceType = .link
        self.preferenceGroup = preferenceGroup
        self.icon = icon
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = linkedPreferences
        self.getInitialState = nil
    }
    
    
    let label: String
    let preferenceType: PreferenceType
    let preferenceGroup: PreferenceGroup
    let prominence: Prominence
    let icon: String?
    let action: (Any?) -> ()
    let linkedPreferences: [UserPreference.PreferenceGroup: [UserPreference]]?
    
    private let getInitialState: (() -> Bool)?
    
    var initialState: Bool? {
        getInitialState?()
    }
    
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
