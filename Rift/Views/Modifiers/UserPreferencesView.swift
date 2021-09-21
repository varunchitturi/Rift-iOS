//
//  UserPreferencesView.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import SwiftUI

struct UserPreferencesView: View {
    let preferenceGroups = UserPreferences.shared
    var body: some View {
        NavigationView {
            List {
                ForEach(preferenceGroups) { group in
                    Section {
                        ForEach(group.preferences) { preference in
                            preference.viewConfiguration
                        }
                    } header: {
                        Text(group.label)
                    }
                }
            }
            .navigationTitle("Preferences")
        }
    }
}

struct UserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesView()
    }
}
