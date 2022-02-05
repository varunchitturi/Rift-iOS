//
//  AnalyticsLogger.swift
//  Rift
//
//  Created by Varun Chitturi on 1/10/22.
//

import Foundation
import Firebase
import SwiftUI

extension View {
    @ViewBuilder func logViewAnalytics<V>(_ view: V) -> some View {
        self
            .onAppear {
                Analytics.logEvent(Analytics.ScreenViewEvent(screenName: String(describing: V.self)))
            }
    }
}
