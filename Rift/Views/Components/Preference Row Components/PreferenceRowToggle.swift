//
//  PreferenceRowToggle.swift
//  PreferenceRowToggle
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

struct PreferenceRowToggle: View {
    
    @State private var toggleState = false {
        willSet {
            preference.action(newValue)
        }
    }
    let preference: UserPreference
    
    init(_ preference: UserPreference) {
        self.preference = preference
        self.toggleState = preference.initialState
    }
    
  
    
    
    var body: some View {
        Toggle(preference.label, isOn: $toggleState)
    }
}

struct PreferenceRowToggle_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRowToggle(UserPreference.shared[.user]![0])
    }
}
