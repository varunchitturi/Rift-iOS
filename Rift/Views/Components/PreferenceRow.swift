//
//  PreferenceRow.swift
//  PreferenceRow
//
//  Created by Varun Chitturi on 9/23/21.
//

import SwiftUI

struct PreferenceRow: View {
    init(_ preference: UserPreferenceModel) {
        self.preference = preference
    }
    
    let preference: UserPreferenceModel
    var body: some View {
        Group {
            switch preference.preferenceType {
            case .toggle:
                PreferenceRowToggle(preference)
            case .button:
                PreferenceRowButton(preference)
            case .link:
                PreferenceRowLink(preference)
            }
        }
        .foregroundColor(preference.prominence == .high ? DrawingConstants.prominentForeground : DrawingConstants.defaultForeground)
    }
    
    private struct DrawingConstants {
        static let prominentForeground = Color("Primary")
        static let defaultForeground = Color("Tertiary")
    }
}

struct PreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRow(UserPreferenceModel.shared[.user]![0])
    }
}
