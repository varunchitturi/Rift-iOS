//
//  UserPreferenceView.swift
//  UserPreferenceView
//
//  Created by Varun Chitturi on 9/23/21.
//

import SwiftUI

struct UserPreferenceView: View {
    init(preferences: [UserPreferenceModel.PreferenceGroup : [UserPreferenceModel]]) {
        self.preferences = preferences
    }
    
    let preferences: [UserPreferenceModel.PreferenceGroup: [UserPreferenceModel]]
    

    
    var body: some View {
        
        
        NavigationView {
            List {
                ForEach(UserPreferenceModel.PreferenceGroup.allCases) { group in
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
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
    }

}



struct UserPreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferenceView(preferences: UserPreferenceModel.shared)
    }
}
