//
//  TextSection.swift
//  Rift
//
//  Created by Varun Chitturi on 10/14/21.
//

import SwiftUI

/// A view to clearly present a section of text
struct TextSection: View {
    
    init(header: String? = nil, _ text: String) {
        self.header = header
        self.text = AttributedString(text)
    }
    
    init(header: String? = nil, _ text: AttributedString) {
        self.header = header
        self.text = text
    }
    
    let header: String?
    let text: AttributedString
    var body: some View {
        VStack(alignment: .leading) {
            if header != nil {
                Text(header!)
                    .font(.caption.bold())
            }
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: DrawingConstants.rectangleCornerRadius)
                    .foregroundColor(Rift.DrawingConstants.backgroundColor)
                Text(text)
                    .font(.callout)
                    .padding()
            }
        }
        .foregroundColor(Rift.DrawingConstants.foregroundColor)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private enum DrawingConstants {
        static let rectangleCornerRadius: CGFloat = 15
    }
}

#if DEBUG
struct TextSection_Previews: PreviewProvider {
    static var previews: some View {
        TextSection(header: "Section Header", try! AttributedString(markdown: "[https//:google.com](https//:google.com)"))
    }
}
#endif
