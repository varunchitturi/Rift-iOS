//
//  ContentView.swift
//  ContentView
//
//  Created by Varun Chitturi on 9/18/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var applicationViewModel = ApplicationViewModel()
    @StateObject private var localeViewModel = LocaleViewModel()
    var body: some View {
        Group {
            let locale = PersistentLocale.getLocale()
            switch applicationViewModel.authenticationState {
            case .loading:
                LoadingView()
            case .authenticated where locale != nil:
                HomeView(locale: locale!)
                    .environmentObject(applicationViewModel)
            default:
                LocaleView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
