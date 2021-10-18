//
//  SectionHeader.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import SwiftUI

struct SectionHeader: View {
    init(_ text: String) {
        self.text = text
    }
    let text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: DrawingConstants.headerHeight, alignment: .leading)
            .background(DrawingConstants.backgroundColor)
            .foregroundColor(DrawingConstants.foregroundColor)
    }
    
    private struct DrawingConstants {
        static let headerHeight: CGFloat = 28
        static let backgroundColor = Color("Secondary")
        static let foregroundColor = Color("Tertiary")
    }
}

#if DEBUG
struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader("Hello")
    }
}
#endif
