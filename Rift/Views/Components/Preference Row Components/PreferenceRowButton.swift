//
//  PreferenceRowButton.swift
//  PreferenceRowButton
//
//  Created by Varun Chitturi on 9/24/21.
//

import SwiftUI

struct PreferenceRowButton: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    init(_ preference: UserPreference) {
        self.preference = preference
    }
    
    let preference: UserPreference
    var body: some View {
        Button {
            preference.action(contentViewModel)
        } label: {
            VStack(alignment: .center) {
                Text(preference.label)
            }
        }
    }
}

struct PreferenceRowButton_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceRowButton(UserPreference.shared[.user]![0])
    }
}
