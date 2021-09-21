//
//  UserPreferencesButton.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import SwiftUI

struct UserPreferencesButton: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        Button {
            homeViewModel.settingsIsPresented = true
        } label: {
            Image(systemName: "gearshape.fill")
        }
    }
}

struct UserPreferencesButton_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesButton()
            .environmentObject(HomeViewModel(locale: PreviewObjects.locale))
    }
}
