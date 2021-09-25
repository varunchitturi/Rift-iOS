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
                    label: "Log Out",
                    preferenceType: .button,
                    preferenceGroup: .user,
                    prominence: .high,
                    action: { contentViewModel in
                        if let contentViewModel = contentViewModel as? ContentViewModel {
                            contentViewModel.isAuthenticated = false
                        }
                    }
                )
        ]
    ]
}
