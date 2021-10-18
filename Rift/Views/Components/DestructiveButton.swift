//
//  DestructiveButton.swift
//  Rift
//
//  Created by Varun Chitturi on 10/16/21.
//

import SwiftUI

struct DestructiveButton: View {
    
    init(_ label: String, action: @escaping () -> ()) {
        self.action = action
        self.label = label
    }
    
    let action: () -> ()
    let label: String
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.rectangleCornerRadius)
                    .foregroundColor(DrawingConstants.foregroundColor)
                Text(label)
                    .foregroundColor(.red)
                    .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Secondary")
        static let rectangleCornerRadius: CGFloat = 15
    }
}

#if DEBUG
struct DestructiveButton_Previews: PreviewProvider {
    static var previews: some View {
        DestructiveButton("Delete") {
            print("Delete")
        }
    }
}
#endif
