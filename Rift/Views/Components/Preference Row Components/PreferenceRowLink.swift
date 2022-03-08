//
//  PreferenceRowLink.swift
//  PreferenceRowLink
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

/// A single row in a `UserPreferenceView` that acts as a `NavigationLink` to a subsection of preferences
struct PreferenceRowLink: View {
    init(_ preference: UserPreferenceModel) {
        self.preference = preference
    }
    
    let preference: UserPreferenceModel
    var body: some View {
        if let preferences = preference.linkedPreferences {
            NavigationLink(destination: UserPreferenceView(preferences: preferences)) {
                VStack(alignment: .center) {
                    Text(preference.label)
                }
            }
        }
    }
}

#if DEBUG
struct PreferenceRowLink_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRowLink(UserPreferenceModel.shared[.user]![0])
    }
}
#endif
