//
//  UserPreferenceView.swift
//  UserPreferenceView
//
//  Created by Varun Chitturi on 9/23/21.
//

import SwiftUI

struct UserPreferenceView: View {
    init(preferences: [UserPreference.PreferenceGroup : [UserPreference]]) {
        self.preferences = preferences
    }
    
    let preferences: [UserPreference.PreferenceGroup: [UserPreference]]
    

    
    var body: some View {
        
        
        NavigationView {
            List {
                ForEach(UserPreference.PreferenceGroup.allCases) { group in
                    if let preferences = preferences[group] {
                        Section(header: Text(group.rawValue)) {
                            ForEach(preferences) { preference in
                                PreferenceRow(preference)
                            }
                        }
                    }
                }
            }
            .foregroundColor(DrawingConstants.foregroundColor)
            .listStyle(.insetGrouped)
            .navigationTitle("Preferences")
        }
    }
}

private struct DrawingConstants {
    static let foregroundColor = Color("Tertiary")
}


struct UserPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferenceView(preferences: UserPreference.shared)
    }
}
