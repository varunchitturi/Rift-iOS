//
//  ContentView.swift
//  ContentView
//
//  Created by Varun Chitturi on 9/18/21.
//

import SwiftUI

struct ContentView: View {
    // TODO: make all view models private
    @State var isAuthenticated = false
    @StateObject private var localeViewModel = LocaleViewModel()
    var body: some View {
        if isAuthenticated && localeViewModel.chosenLocale != nil {
            HomeView(locale: localeViewModel.chosenLocale!)
        }
        else {
            LocaleView(viewModel: localeViewModel, authenticationState: $isAuthenticated)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
