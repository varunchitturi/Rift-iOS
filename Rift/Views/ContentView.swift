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

            WelcomeView()
                .environmentObject(applicationViewModel)
                .apiHandler(asyncState: applicationViewModel.networkState) {
                    ApplicationView(locale: locale)
                        .environmentObject(applicationViewModel)
                } loadingView: {
                    ProgressView("Logging In")
                } retryAction: { _ in
                    applicationViewModel.authenticateUsingCookies()
                }


        }
        .navigationBarColor(backgroundColor: DrawingConstants.accentColor)
        .usingCustomTableViewStyle()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
