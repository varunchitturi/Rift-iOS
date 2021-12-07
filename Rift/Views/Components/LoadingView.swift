//
//  LoadingView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/2/21.
//

import SwiftUI

struct LoadingView: View {
    @State private var isRotating = false
    var body: some View {
        ZStack(alignment: .center) {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: DrawingConstants.loaderWidth)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(
                    .linear(duration: DrawingConstants.animationDuration)
                        .repeatForever(autoreverses: false)
                )
                .onAppear {
                    isRotating = true
                }
                
        }
    }
    
    private struct DrawingConstants {
        static let loaderWidth: CGFloat = 80
        static let animationDuration: CGFloat = 2
    }
}


#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
