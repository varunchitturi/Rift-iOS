//
//  CircleBadge.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct CircleBadge: View {
    init(_ text: String?) {
        self.text = text
    }
    
    let text: String?
    var body: some View {
        Circle()
            .fill(DrawingConstants.circleBackground)
            .frame(minWidth: DrawingConstants.minCircleDiameter,
                   maxWidth: DrawingConstants.maxCircleDiameter,
                   minHeight: DrawingConstants.minCircleDiameter,
                   maxHeight: DrawingConstants.maxCircleDiameter,
                   alignment: .trailing)
            .overlay(
                Text(text ?? "-")
                    .fontWeight(.semibold)
                    .frame(maxWidth: DrawingConstants.maxCircleDiameter)
                    .scaledToFill()
                    .minimumScaleFactor(0.01)
                    .foregroundColor(DrawingConstants.circleForeground)
                    .padding(9)
                    
            )
    }
    
    private struct DrawingConstants {
        static let minCircleDiameter: CGFloat = 30.0
        static let maxCircleDiameter: CGFloat = 35.0
        static let circleForeground = Color("Foreground")
        static let circleBackground = Color("Background")
    }
}

struct CircleBadge_Previews: PreviewProvider {
    static var previews: some View {
        CircleBadge("100")
    }
}
