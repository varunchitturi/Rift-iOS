//
//  ContentView.swift
//  ContentView
//
//  Created by Varun Chitturi on 9/18/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var applicationViewModel = ApplicationViewModel()
    var body: some View {
        Group {
            ApplicationView(viewModel: applicationViewModel)
                .apiHandler(asyncState: applicationViewModel.networkState, loadingStyle: .progressCircle) { _ in
                    applicationViewModel.authenticateUsingCookies()
                }
        }
        .navigationBarColor(backgroundColor: DrawingConstants.accentColor)
        .usingCustomTableViewStyle()
        .environmentObject(applicationViewModel)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
