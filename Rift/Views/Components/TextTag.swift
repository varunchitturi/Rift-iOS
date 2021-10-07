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
        Text("  \(text)  ")
            .font(.caption2)
            .fontWeight(.bold)
            .lineLimit(1)
            .foregroundColor(DrawingConstants.foregroundColor)
            .background (
                RoundedRectangle(cornerRadius: DrawingConstants.tagCornerRadius)
                        .foregroundColor(
                            DrawingConstants.backgroundColor
                        )
            )
            
            .frame(maxWidth: DrawingConstants.maxTagWidth)
            .fixedSize()
    }
    
    private struct DrawingConstants {
        
        static let backgroundColor = Color("Background")
        static let foregroundColor = Color("Foreground")
        static let tagCornerRadius: CGFloat = 3
        static let maxTagWidth: CGFloat = 100
    }
}

struct TextTag_Previews: PreviewProvider {
    static var previews: some View {
        TextTag("Test")
    }
}
