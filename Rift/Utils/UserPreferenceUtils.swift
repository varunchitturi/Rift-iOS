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
                    action: { viewModels in
                        if let viewModels = viewModels as? (ApplicationViewModel, HomeViewModel) {
                            let applicationViewModel = viewModels.0
                            let homeViewModel = viewModels.1
                            let urlRequest = URLRequest(url: homeViewModel.locale.districtBaseURL
                                                            .appendingPathComponent(LogIn.API.logOutEndpoint)
                            )
                            URLSession.shared.dataTask(with: urlRequest) { _, _, error in
                                if let error = error {
                                    print(error)
                                    // TODO: better error handling here
                                }
                                else {
                                    HTTPCookieStorage.shared.removeCookies(since: .distantPast)
                                    DispatchQueue.main.async {
                                        applicationViewModel.isAuthenticated = false
                                    }
                                }
                            }.resume()
                        }
                    }
                )
        ]
    ]
}
