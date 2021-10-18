//
//  ContentView.swift
//  ContentView
//
//  Created by Varun Chitturi on 9/18/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var applicationViewModel = ApplicationViewModel()
    @StateObject private var welcomeViewModel = WelcomeViewModel()
    var body: some View {
        Group {
            let locale = PersistentLocale.getLocale()
            switch applicationViewModel.authenticationState {
            case .loading:
                LoadingView()
            case .authenticated where locale != nil:
                HomeView()
                    .environmentObject(applicationViewModel)
            default:
                WelcomeView()
                    .environmentObject(applicationViewModel)
            }
        }
        .navigationBarColor(backgroundColor: DrawingConstants.navigationColor)
        .usingCustomTableViewStyle()
       
    }
}

private struct DrawingConstants {
    static let navigationColor = Color("Primary")
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
