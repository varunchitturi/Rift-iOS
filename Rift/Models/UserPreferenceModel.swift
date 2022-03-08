//
//  UserPreferenceModel.swift
//  UserPreferenceModel
//
//  Created by Varun Chitturi on 9/23/21.
//

import Foundation
import UIKit

/// MVVM model to manage the User Preferences View
struct UserPreferenceModel: Identifiable {
    
    // TODO: switch to protocol based inheritance
    // TODO: label this the toggle initializer
    // TODO: describe API for User Preference
    init(label: String, getInitialState: @escaping () -> Bool, preferenceGroup: PreferenceGroup, prominence: UserPreferenceModel.Prominence = .low, action: @escaping (Any?) -> (), configuration: () -> () = {}) {
        configuration()
        self.label = label
        self.preferenceType = .toggle
        self.preferenceGroup = preferenceGroup
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = nil
        self.getInitialState = getInitialState
    }
    
    // TODO: label this the button initializer
    init(label: String, preferenceGroup: PreferenceGroup, prominence: UserPreferenceModel.Prominence = .low, action: @escaping (Any?) -> (), configuration: () -> () = {}) {
        configuration()
        self.label = label
        self.preferenceType = .button
        self.preferenceGroup = preferenceGroup
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = nil
        self.getInitialState = nil
    }

    // TODO: label this the link initializer
    
    init(label: String, preferenceGroup: PreferenceGroup, prominence: UserPreferenceModel.Prominence = .low, action: @escaping (Any?) -> (), linkedPreferences: [UserPreferenceModel.PreferenceGroup: [UserPreferenceModel]], configuration: () -> () = {}) {
        configuration()
        self.label = label
        self.preferenceType = .link
        self.preferenceGroup = preferenceGroup
        self.prominence = prominence
        self.action = action
        self.linkedPreferences = linkedPreferences
        self.getInitialState = nil
    }
    
    
    /// A unique label for the user preference
    let label: String
    
    /// The way that the user configures the preference
    let preferenceType: PreferenceType
    
    /// The group of preference that the current preference is part of
    let preferenceGroup: PreferenceGroup
    
    /// The prominence for this preference
    ///  - Changes how prominently the preference is presented to the user
    let prominence: Prominence
    
    /// The action run if the user clicks on the preference and the preference type is a button
    let action: (Any?) -> ()
    
    /// A dictionary of linked preferences if available
    let linkedPreferences: [UserPreferenceModel.PreferenceGroup: [UserPreferenceModel]]?
    
    /// A closure run to get the initial state of the preference
    /// - For example, this is run to set the initial state of a toggle preference
    private let getInitialState: (() -> Bool)?
    
    /// The initial state of the preference
    ///   - Runs `getInitialState()` in order to get this value
    var initialState: Bool? {
        getInitialState?()
    }
    
    /// The `id` for this preference`
    /// - Calculated from the label for this preference.
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
        case user = "User", courses = "Courses", assignments = "Assignments", notifications = "Notifications", links = "Links"
    }
    
    enum Prominence {
        case high, low
    }
    
}

