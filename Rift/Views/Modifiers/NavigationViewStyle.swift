//
//  NavigationViewStyle.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//

import SwiftUI
import UIKit

private struct NavigationViewStyle: ViewModifier {
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(backgroundColor: Color, foregroundColor: Color? = nil) {
        self.foregroundColor = foregroundColor ?? (backgroundColor.isLight() ? .black : .white)
        self.backgroundColor = backgroundColor
        let foregroundAppearance = UINavigationBarAppearance()
        foregroundAppearance.configureWithTransparentBackground()
        foregroundAppearance.backgroundColor = UIColor(self.backgroundColor)
        foregroundAppearance.titleTextAttributes = [.foregroundColor: UIColor(self.foregroundColor)]
        foregroundAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(self.foregroundColor)]
        UINavigationBar.appearance().standardAppearance = foregroundAppearance
        UINavigationBar.appearance().compactAppearance = foregroundAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = foregroundAppearance
        UINavigationBar.appearance().tintColor = UIColor(self.foregroundColor)
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    @available(iOS, deprecated: 16, message: "Use `.toolbarBackground`")
    func navigationBarColor(backgroundColor: Color, foregroundColor: Color? = nil) -> some View {
        modifier(NavigationViewStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}
