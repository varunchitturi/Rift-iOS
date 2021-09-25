//
//  PreferenceRow.swift
//  PreferenceRow
//
//  Created by Varun Chitturi on 9/23/21.
//

import SwiftUI

struct PreferenceRow: View {
    init(_ preference: UserPreference) {
        self.preference = preference
    }
    
    let preference: UserPreference
    var body: some View {
        switch preference.preferenceType {
        case .toggle:
            PreferenceRowToggle(preference)
        case .button:
            PreferenceRowButton(preference)
        case .link:
            PreferenceRowLink(preference)
        }
    }
}

struct PreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRow(UserPreference.shared[.user]![0])
    }
}
