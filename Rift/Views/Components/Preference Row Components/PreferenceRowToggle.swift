//
//  PreferenceRowToggle.swift
//  PreferenceRowToggle
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

struct PreferenceRowToggle: View {
    init(_ preference: UserPreference) {
        self.preference = preference
    }
    
  
    let preference: UserPreference
    @State private var toggleState = false {
        willSet {
            preference.action(newValue)
        }
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
