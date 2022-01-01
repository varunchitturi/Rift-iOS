//
//  TabViewStyle.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI
import UIKit

private struct CustomTabViewStyle: ViewModifier {
    
    
    init() {
        UITabBar.appearance().tintAdjustmentMode = .normal
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func usingCustomTabViewStyle() -> some View {
        modifier(CustomTabViewStyle())
    }
}
