//
//  TextTag.swift
//  Rift
//
//  Created by Varun Chitturi on 10/6/21.
//

import SwiftUI

/// A tag like view for `Text` views
/// - Colored text with a contrasting background
struct TextTag: View {
    
    init(_ text: String) {
        self.text = text
    }
    
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Rift.DrawingConstants.accentForegroundColor)
            .font(.caption2)
            .fontWeight(.bold)
            .lineLimit(1)
            .padding(.vertical, DrawingConstants.verticalPadding)
            .padding(.horizontal, DrawingConstants.horizontalPadding)
            .clipped()
            .background(Rift.DrawingConstants.accentBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.tagCornerRadius))
    }
    
    private enum DrawingConstants {
        static let tagCornerRadius: CGFloat = 3
        static let verticalPadding: CGFloat = 1
        static let horizontalPadding: CGFloat = 4
    }
}

#if DEBUG
struct TextTag_Previews: PreviewProvider {
    static var previews: some View {
        TextTag("Test")
    }
}
#endif
