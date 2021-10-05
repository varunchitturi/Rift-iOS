//
//  UserPreferenceUtils.swift
//  UserPreferenceUtils
//
//  Created by Varun Chitturi on 9/23/21.
//

import Foundation
import SwiftUI

extension UserPreference {
    
    
    // TODO: implement a style guide
    static let persistencePreferenceKey = "persistence"
    
    static let shared: [UserPreference.PreferenceGroup: [UserPreference]] = [
        .user: [
                UserPreference(
                    label: "Stay Logged In",
                    getInitialState: {
                        return UserDefaults.standard.bool(forKey: UserPreference.persistencePreferenceKey)
                    },
                    preferenceGroup: .user,
                    prominence: .low,
                    action: { toggleValue in
                        if let toggleValue = toggleValue as? Bool {
                            UserDefaults.standard.set(toggleValue, forKey: UserPreference.persistencePreferenceKey)
                        }
                    },
                    configuration: {
                        UserDefaults.standard.register(defaults: [UserPreference.persistencePreferenceKey : false])
                    }
                ),
                UserPreference(
                    label: "Log Out",
                    preferenceGroup: .user,
                    prominence: .high,
                    action: { viewModels in
                        if let viewModels = viewModels as? (ApplicationViewModel, HomeViewModel) {
                            let applicationViewModel = viewModels.0
                            API.Authentication.logOut { _ in
                                applicationViewModel.resetApplicationState()
                            }
                        }
                    }
                )
        ]
    ]
}
