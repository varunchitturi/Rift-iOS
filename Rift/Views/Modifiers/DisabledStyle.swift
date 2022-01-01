//
//  DisabledStyle.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI

private struct Disableable: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    func body(content: Content) -> some View {
        if isEnabled {
            return content.opacity(DrawingConstants.enabledOpacity)
        }
        return content.opacity(DrawingConstants.disabledOpacity)
    }
    private struct DrawingConstants {
        static let disabledOpacity = 0.6
        static let enabledOpacity: Double = 1
    }
}

extension View {
    func disableable() -> some View {
        modifier(Disableable())
    }
}
