//
//  CircleBadge.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct CircleBadge: View {
    
    
    init(_ text: String, size: Size = .default) {
        self.text = text
        self.size = size
        minDiameter = DrawingConstants.minCircleDiameter
        maxDiameter = DrawingConstants.maxCircleDiameter
        textPadding = DrawingConstants.textPadding
        if size == .large {
            minDiameter *= DrawingConstants.largeStyleMultiplier
            maxDiameter *= DrawingConstants.largeStyleMultiplier
        }
        
    }
    
    let text: String
    let size: Size
    private var minDiameter: CGFloat
    private var maxDiameter: CGFloat
    private var textPadding: CGFloat
    var body: some View {
        Circle()
            .fill(DrawingConstants.circleBackground)
            .frame(minWidth: minDiameter,
                   maxWidth: maxDiameter,
                   minHeight: minDiameter,
                   maxHeight: maxDiameter,
                   alignment: .trailing)
            .overlay(
                Text(text)
                    .font(size == .default ? .body : .title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: maxDiameter)
                    .scaledToFill()
                    .minimumScaleFactor(DrawingConstants.fontMinimumScale)
                    .foregroundColor(DrawingConstants.circleForeground)
                    .padding(textPadding)
                    
            )
    }
    
    enum Size {
        case large
        case `default`
    }
    
    private struct DrawingConstants {
        static let textPadding: CGFloat = 9
        static let fontMinimumScale: CGFloat = 0.01
        static let minCircleDiameter: CGFloat = 30.0
        static let largeStyleMultiplier = 1.2
        static let maxCircleDiameter: CGFloat = 35.0
        static let circleForeground = Color("Foreground")
        static let circleBackground = Color("Background")
    }
}

struct CircleBadge_Previews: PreviewProvider {
    static var previews: some View {
        CircleBadge("100", size: .large)
        CircleBadge("100")
    }
}
