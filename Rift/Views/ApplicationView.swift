//
//  Application'View.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation
import SwiftUI

struct ApplicationView: View {
    
    init(viewModel: ApplicationViewModel) {
        self.applicationViewModel = viewModel
        
    }
    
    @ObservedObject var applicationViewModel: ApplicationViewModel

    var body: some View {
        switch applicationViewModel.authenticationState {
        case .authenticated where applicationViewModel.locale != nil:
            HomeView()
                .environmentObject(applicationViewModel)
        default:
            WelcomeView()
                .environmentObject(applicationViewModel)
        }
    }
}
