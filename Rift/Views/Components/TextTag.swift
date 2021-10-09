//
//  TextTag.swift
//  Rift
//
//  Created by Varun Chitturi on 10/6/21.
//

import SwiftUI

struct TextTag: View {
    
    init(_ text: String) {
        self.text = text
    }
    
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(DrawingConstants.foregroundColor)
            .font(.caption2)
            .fontWeight(.bold)
            .lineLimit(1)
            .padding(.vertical, DrawingConstants.verticalPadding)
            .padding(.horizontal, DrawingConstants.horizontalPadding)
            .clipped()
            .background(DrawingConstants.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.tagCornerRadius))
    }
    
    private struct DrawingConstants {
        
        static let backgroundColor = Color("Background")
        static let foregroundColor = Color("Foreground")
        static let tagCornerRadius: CGFloat = 3
        static let verticalPadding: CGFloat = 1
        static let horizontalPadding: CGFloat = 4
    }
}

struct TextTag_Previews: PreviewProvider {
    static var previews: some View {
        TextTag("Test")
    }
}
