//
//  UserPreferenceUtils.swift
//  UserPreferenceUtils
//
//  Created by Varun Chitturi on 9/23/21.
//

import Foundation
import SwiftUI

extension UserPreference {
    static let shared: [UserPreference.PreferenceGroup: [UserPreference]] = [
        .user: [
                UserPreference(
                    label: "Stay Logged In",
                    getInitialState: {
                        print(UserDefaults.standard.bool(forKey: LogIn.persistencePreferenceKey))
                        return UserDefaults.standard.bool(forKey: LogIn.persistencePreferenceKey)
                    },
                    preferenceGroup: .user,
                    prominence: .low,
                    action: { toggleValue in
                        if let toggleValue = toggleValue as? Bool {
                            UserDefaults.standard.set(toggleValue, forKey: LogIn.persistencePreferenceKey)
                            // TODO: if toggle value is true make a network request
                        }
                    },
                    configuration: {
                        UserDefaults.standard.register(defaults: [LogIn.persistencePreferenceKey : false])
                    }
                ),
                UserPreference(
                    label: "Log Out",
                    preferenceGroup: .user,
                    prominence: .high,
                    action: { applicationViewModel in
                        if let applicationViewModel = applicationViewModel as? ApplicationViewModel {
                            // TODO: invalidate jsession here
                            HTTPCookieStorage.shared.removeCookies(since: .distantPast)
                            applicationViewModel.isAuthenticated = false
                        }
                    }
                )
        ]
    ]
}
