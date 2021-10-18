//
//  TextDivider.swift
//  Rift
//
//  Created by Varun Chitturi on 8/28/21.
//

import SwiftUI

struct TextDivider: View {
    init(_ text: String = "") {
        self.text = text
    }
    
    let text: String
    
    var body: some View {
        Divider()
            .overlay(
                Text(text)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding([.horizontal])
                    .background(
                        Rectangle()
                            .fill(Color(UIColor.systemBackground))
                    )
            )
    }
}

#if DEBUG
struct TextDivider_Previews: PreviewProvider {
    static var previews: some View {
        TextDivider("or")
            .foregroundColor(Color("Tertiary"))
    }
}
#endif
