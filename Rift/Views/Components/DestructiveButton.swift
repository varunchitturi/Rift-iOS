//
//  DestructiveButton.swift
//  Rift
//
//  Created by Varun Chitturi on 10/16/21.
//

import SwiftUI

/// A full-width button with red text and a contrasting background to indicate a destructive action
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
                    .fill(Rift.DrawingConstants.backgroundColor)
                Text(label)
                    .foregroundColor(Rift.DrawingConstants.destructiveTextColor)
                    .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private enum DrawingConstants {
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
