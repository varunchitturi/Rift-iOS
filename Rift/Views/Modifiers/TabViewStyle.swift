//
//  TabViewStyle.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI
import UIKit

struct TabViewStyle: ViewModifier {
    let backgroundColor: Color
    let unselectedColor: Color
    
    
    init(backgroundColor: Color? = nil, unselectedColor: Color? = nil) {
        if let unselectedColor = unselectedColor {
            self.unselectedColor = unselectedColor
            UITabBar.appearance().unselectedItemTintColor = UIColor(unselectedColor)
        }
        else {
            self.unselectedColor = Color(UITabBar.appearance().unselectedItemTintColor ?? .clear)
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
            UITabBar.appearance().barTintColor = UIColor(backgroundColor)
        }
        else {
            self.backgroundColor = Color(UITabBar.appearance().barTintColor ?? .clear)
        }
        UITabBar.appearance().isTranslucent = false
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func tabViewStyle(backgroundColor: Color? = nil, unselectedColor: Color? = nil) -> some View {
        modifier(TabViewStyle(backgroundColor: backgroundColor, unselectedColor: unselectedColor))
    }
}
