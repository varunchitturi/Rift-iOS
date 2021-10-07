//
//  UserPreferenceModel.swift
//  UserPreferenceModel
//
//  Created by Varun Chitturi on 9/23/21.
//

import Foundation

struct UserPreferenceModel: Identifiable {
    
    // TODO: switch to protocol based inheritance
    // TODO: label this the toggle initializer
    // TODO: describe API for User Preference
    init(label: String, getInitialState: @escaping () -> Bool, preferenceGroup: PreferenceGroup, prominence: UserPreferenceModel.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), configuration: () -> () = {}) {
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
    init(label: String, preferenceGroup: PreferenceGroup, prominence: UserPreferenceModel.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), configuration: () -> () = {}) {
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
    
    init(label: String, preferenceGroup: PreferenceGroup, prominence: UserPreferenceModel.Prominence = .low, icon: String? = nil, action: @escaping (Any?) -> (), linkedPreferences: [UserPreferenceModel.PreferenceGroup: [UserPreferenceModel]], configuration: () -> () = {}) {
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
    let linkedPreferences: [UserPreferenceModel.PreferenceGroup: [UserPreferenceModel]]?
    
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
        case user = "User", courses = "Courses", assignments = "Assignments", notifications = "Notifications"
    }
    
    enum Prominence {
        case high, low
    }
    
}
