//
//  PreferenceRowToggle.swift
//  PreferenceRowToggle
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

struct PreferenceRowToggle: View {
    
    @State private var toggleState: Bool
    
    let preference: UserPreference
    
    init(_ preference: UserPreference) {
        print("initializing view")
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

struct PreferenceRowToggle_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRowToggle(UserPreference.shared[.user]![0])
    }
}
