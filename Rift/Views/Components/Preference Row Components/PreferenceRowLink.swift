//
//  PreferenceRowLink.swift
//  PreferenceRowLink
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

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

struct PreferenceRowLink_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRowLink(UserPreferenceModel.shared[.user]![0])
    }
}
