//
//  Application'View.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation
import SwiftUI

struct ApplicationView: View {
    @EnvironmentObject private var applicationViewModel: ApplicationViewModel
    let locale: Locale?

    var body: some View {
        switch applicationViewModel.authenticationState {
        case .authenticated where locale != nil:
            HomeView()
                .environmentObject(applicationViewModel)
        default:
            WelcomeView()
                .environmentObject(applicationViewModel)
        }
    }
}
