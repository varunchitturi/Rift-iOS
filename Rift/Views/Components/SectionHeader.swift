//
//  SectionHeader.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

/// A text header with a full-width, contrasting background
struct SectionHeader: View {
    init(_ text: String) {
        self.text = text
    }
    let text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: DrawingConstants.headerHeight, alignment: .leading)
            .background(Rift.DrawingConstants.backgroundColor)
            .foregroundColor(Rift.DrawingConstants.foregroundColor)
    }
    
    private enum DrawingConstants {
        static let headerHeight: CGFloat = 28
    }
}

#if DEBUG
struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader("Hello")
    }
}
#endif
