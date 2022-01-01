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
    
    
    // TODO: implement a style guide
    static let persistencePreferenceKey = "persistence"
    
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
                            API.Authentication.logOut { _ in
                                Analytics.logEvent("log_out", parameters: nil)
                                FirebaseApp.clearUser()
                                DispatchQueue.main.async {
                                    applicationViewModel.resetApplicationState()
                                }
                            }
                        }
                    }
                )
        ]
    ]
}
