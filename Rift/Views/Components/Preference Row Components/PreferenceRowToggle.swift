//
//  PreferenceRowToggle.swift
//  PreferenceRowToggle
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

/// A single row in a `UserPreferenceView` with a toggle button
struct PreferenceRowToggle: View {
    
    @State private var toggleState: Bool
    
    let preference: UserPreferenceModel
    
    init(_ preference: UserPreferenceModel) {
        self.preference = preference
        self.toggleState = preference.initialState ?? false
    }
    
  
    
    
    var body: some View {
        Toggle(preference.label, isOn: $toggleState)
            .onChange(of: toggleState) { newValue in
                preference.action(newValue)
            }
    }
}

#if DEBUG
struct PreferenceRowToggle_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRowToggle(UserPreferenceModel.shared[.user]![0])
    }
}
#endif
