//
//  GlobalDrawingConstants.swift
//  Rift
//
//  Created by Varun Chitturi on 12/8/21.
//

import Foundation
import SwiftUI

enum DrawingConstants {
    
    /// The accent color for this app
    static let accentColor = Color("Primary")
    
    /// Default color for foreground text
    static let foregroundColor = Color("Tertiary")
    
    /// A lighter foreground color for secondary text
    static let secondaryForegroundColor = Color("Quaternary")
    
    /// An accented foreground color
    /// - Slightly lighter than `accentColor`
    static let accentForegroundColor = Color("AccentSecondary")
    
    /// A foreground color to use on backgrounds that are of `accentColor`
    static let inverseForegroundColor = Color("Secondary")
    
    /// Default color for background items
    static let backgroundColor = Color("Secondary")
    
    /// An accented background color
    /// - Slightly dimmer color than `accentColor`
    static let accentBackgroundColor = Color("AccentTertiary")
    
    /// Default color for destructive text
    static let destructiveTextColor = Color.red
    
    /// Default color for disabled elements
    static let disabledColor = Color("Quaternary")
    
    /// The opacity for disabled elements
    static let disableOpacity: CGFloat = 0.6
    
    /// The default amount of decimal numbers allowed
    static let decimalCutoff: Int = 2
    
}
