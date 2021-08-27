//
//  TabBar.swift
//  Rift
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        HStack(alignment: .bottom){
            Rectangle()
                .cornerRadius(DrawingConstants.barCornerRadius, corners: [.topLeft, .topRight])
                .foregroundColor(Color("Secondary"))
                .frame(minHeight: DrawingConstants.barMinHeight, idealHeight: DrawingConstants.barIdealHeight, maxHeight: DrawingConstants.barMaxHeight, alignment: .bottom)
                .shadow(color: Color("Tertiary").opacity(DrawingConstants.barShadowOpacity), radius: DrawingConstants.barShadowRadius, x: DrawingConstants.barShadowXOffset, y: DrawingConstants.barShadowYOffset)
        }
    }
    private struct DrawingConstants {
        static let barCornerRadius: CGFloat = 40
        static let barMinHeight: CGFloat = 85
        static let barIdealHeight: CGFloat = 90
        static let barMaxHeight: CGFloat = 90
        static let barShadowOpacity: CGFloat = 0.1
        static let barShadowRadius: CGFloat = 7
        static let barShadowXOffset: CGFloat = 0
        static let barShadowYOffset: CGFloat = -5
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .padding(.top)
            .previewLayout(.sizeThatFits)
    }
}
