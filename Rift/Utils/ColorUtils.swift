//
//  ColorUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//
import SwiftUI

extension Color {
    
    var components: (red: CGFloat, blue: CGFloat, green: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, o: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)
        return (r, g, b, o)
    }
    
    func isLight() -> Bool {
        let components = self.components
        let brightness = (components.red * 299 + components.green * 587 + components.blue * 114)/100
        return brightness > 125
    }
    
    func isDark() -> Bool {
        !isLight()
    }
}
