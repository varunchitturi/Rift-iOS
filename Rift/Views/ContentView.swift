//
//  ContentView.swift
//  ContentView
//
//  Created by Varun Chitturi on 9/18/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contentViewModel = ContentViewModel()
    @StateObject private var localeViewModel = LocaleViewModel()
    var body: some View {
        Group {
            if contentViewModel.isAuthenticated && localeViewModel.chosenLocale != nil {
                HomeView(locale: localeViewModel.chosenLocale!)
                    .environmentObject(contentViewModel)
            }
            else {
                LocaleView(viewModel: localeViewModel)
                    .environmentObject(contentViewModel)
            }
        }
        .navigationBarColor(backgroundColor: DrawingConstants.navigationColor)
       
    }
}

private struct DrawingConstants {
        static let navigationColor = Color("Primary")
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
