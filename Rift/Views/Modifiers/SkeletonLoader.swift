//
//  SkeletonLoader.swift
//  Rift
//
//  Created by Varun Chitturi on 12/3/21.
//

import Foundation
import SwiftUI
import Shimmer

struct CustomSkeletonLoader<V>: ViewModifier where V: View {
 
    let isLoading: Bool
    let loadingView: () -> V
    
    func body(content: Content) -> some View {
        if isLoading {
            loadingView()
        }
        else {
            content
        }
    }
}

struct DefaultSkeletonLoader: ViewModifier {
 
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .disabled(true)
                .redacted(reason: .placeholder)
                .shimmering()
        }
        else {
            content
        }
    }
}

extension View {
    func skeletonLoad<V>(_ isLoading: Bool, @ViewBuilder loadingView: @escaping () -> V) -> some View where V: View {
        modifier(CustomSkeletonLoader(isLoading: isLoading, loadingView: loadingView))
    }
    
    func skeletonLoad(_ isLoading: Bool = true) -> some View {
        modifier(DefaultSkeletonLoader(isLoading: isLoading))
    }
}
