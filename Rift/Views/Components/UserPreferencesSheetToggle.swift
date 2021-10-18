//
//  UserPreferencesSheetToggle.swift
//  Rift
//
//  Created by Varun Chitturi on 9/21/21.
//

import SwiftUI

struct UserPreferencesSheetToggle: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        Button {
            homeViewModel.settingsIsPresented = true
        } label: {
            Image(systemName: "gearshape.fill")
        }
    }
}

#if DEBUG
struct UserPreferencesSheetToggle_Previews: PreviewProvider {
    static var previews: some View {
        UserPreferencesSheetToggle()
            .environmentObject(HomeViewModel())
    }
}
#endif
