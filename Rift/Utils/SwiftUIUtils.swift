//
//  SwiftUIUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 12/11/22.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content?) -> some View {
        if let view = transform(self), !(view is EmptyView) {
            view
        } else {
            self
        }
    }
}

