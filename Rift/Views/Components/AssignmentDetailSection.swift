//
//  AssignmentDetailSection.swift
//  Rift
//
//  Created by Varun Chitturi on 10/14/21.
//

import SwiftUI

struct AssignmentDetailSection: View {
    
    init(header: String? = nil, _ text: String) {
        self.header = header
        self.text = text
    }
    
    let header: String?
    let text: String
    var body: some View {
        VStack(alignment: .leading) {
            if header != nil {
                Text(header!)
                    .font(.caption.bold())
            }
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: DrawingConstants.rectangleCornerRadius)
                    .foregroundColor(DrawingConstants.backgroundColor)
                Text(text)
                    .font(.callout)
                    .padding()
            }
        }
        .foregroundColor(DrawingConstants.foregroundColor)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private struct DrawingConstants {
        static let rectangleCornerRadius: CGFloat = 15
        static let backgroundColor = Color("Secondary")
        static let foregroundColor = Color("Tertiary")
    }
}

#if DEBUG
struct AssignmentDetailSection_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailSection(header: "Section Header", "This is an assignment detail section")
    }
}
#endif
