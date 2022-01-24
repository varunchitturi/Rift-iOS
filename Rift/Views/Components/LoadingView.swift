//
//  LoadingView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/2/21.
//

import SwiftUI

struct LoadingView: View {
    @State private var isRotating = false
    private var animationStyle: Animation = .linear(duration: DrawingConstants.animationDuration).repeatForever(autoreverses: false)
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
            .stroke(style: StrokeStyle(lineWidth: DrawingConstants.loaderLineWidth + 1, lineCap: .round))
                .fill(Rift.DrawingConstants.accentBackgroundColor)
                .frame(width: DrawingConstants.loaderSize)
            Circle()
                .trim(from: 0, to: DrawingConstants.loaderArcLength)
            .stroke(style: StrokeStyle(lineWidth: DrawingConstants.loaderLineWidth, lineCap: .round))
                .fill(Rift.DrawingConstants.accentColor)
                .frame(width: DrawingConstants.loaderSize)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(animationStyle, value: isRotating)
        }
        .onAppear {
            DispatchQueue.main.async {
                isRotating = true
            }
        }
    }

    private enum DrawingConstants {
        static let loaderLineWidth: CGFloat = 5
        static let animationDuration: CGFloat = 0.5
        static let loaderSize: CGFloat = 35
        static let loaderArcLength: CGFloat = 0.2
    }
}


#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                LoadingView()
            }
        }
    }
}
#endif
