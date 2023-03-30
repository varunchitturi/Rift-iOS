//
//  UserPreferenceUtils.swift
//  UserPreferenceUtils
//
//  Created by Varun Chitturi on 9/23/21.
//

import Firebase
import Foundation
import SwiftUI

extension UserPreferenceModel {
    
    ///  The key in the `UserDefaults` storage for whether the user should stay logged in or not
    static let persistencePreferenceKey = "persistence"
    
    /// A collection of User Preferences that should be displayed in a settings/user preferences view
    static let shared: [UserPreferenceModel.PreferenceGroup: [UserPreferenceModel]] = [
        .user: [
                UserPreferenceModel(
                    label: "Stay Logged In",
                    getInitialState: {
                        return UserDefaults.standard.bool(forKey: UserPreferenceModel.persistencePreferenceKey)
                    },
                    preferenceGroup: .user,
                    prominence: .low,
                    action: { toggleValue in
                        if let toggleValue = toggleValue as? Bool {
                            UserDefaults.standard.set(toggleValue, forKey: UserPreferenceModel.persistencePreferenceKey)
                        }
                    },
                    configuration: {
                        UserDefaults.standard.register(defaults: [UserPreferenceModel.persistencePreferenceKey : false])
                    }
                ),
                UserPreferenceModel(
                    label: "Log Out",
                    preferenceGroup: .user,
                    prominence: .high,
                    action: { viewModels in
                        if let viewModels = viewModels as? (ApplicationViewModel, HomeViewModel) {
                            let applicationViewModel = viewModels.0
                            let homeViewModel = viewModels.1
                            applicationViewModel.logOut()
                        }
                    }
                )
        ],
        .links: [
            UserPreferenceModel(label: "\(Bundle.main.displayName ?? "App") Website",
                                preferenceGroup: .links,
                                action: { _ in
                                    guard let url = URL(string: "https://riftapp.io/") else { return }
                                    UIApplication.shared.open(url)
                                }
            ),
            UserPreferenceModel(label: "Support",
                                preferenceGroup: .links,
                                action: { _ in
                                    guard let url = URL(string: "mailto:support@schoolscope.org") else { return }
                                    UIApplication.shared.open(url)
                                }
            ),
            UserPreferenceModel(label: "Terms and Conditions",
                                preferenceGroup: .links,
                                action: { _ in
                                    guard let url = URL(string: "https://riftapp.io/terms") else { return }
                                    UIApplication.shared.open(url)
                                }
            ),
            UserPreferenceModel(label: "Privacy Policy",
                                preferenceGroup: .links,
                                action: { _ in
                                    guard let url = URL(string: "https://riftapp.io/privacy") else { return }
                                    UIApplication.shared.open(url)
                                }
            )
        ]
    ]
}
