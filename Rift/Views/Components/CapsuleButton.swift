//
//  SwiftUIView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/21/21.
//

import SwiftUI

struct CapsuleButton: View {

    var label: String
    var icon: String?
    let style: Style
    private var action: (() -> Void)?
    
    init(_ label: String, icon: String? = nil, style: CapsuleButton.Style, action: (() -> Void)? = nil) {
        self.label = label
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    
    @ViewBuilder
    private var labelView: some View {
        HStack{
            Spacer()
            Text(label)
            if icon != nil {
                Image(systemName: icon!)
            }
            Spacer()
        }.padding()
        .font(.headline)
        .foregroundColor(self.style.foregroundColor)
        .background(
                Capsule()
                    .fill(self.style.backgroundColor)
        )
    }
    
    var body: some View {
        if action != nil {
            Button {
                action!()
            } label: {
                labelView
            }
            .disabledStyle()
        }
        else {
            labelView
                .disabledStyle()
        }
    }
    
    enum Style {
        case primary, secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return DrawingConstants.primaryColor
            case .secondary:
                return DrawingConstants.secondaryColor
            }
        }
        var foregroundColor: Color {
            switch self {
            case .primary:
                return DrawingConstants.secondaryColor
            case .secondary:
                return DrawingConstants.primaryColor
            }
        }
    }
    private struct DrawingConstants {
        static let disabledOpacity = 0.6
        static let primaryColor = Color("Primary")
        static let secondaryColor = Color("Secondary")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton("Primary", icon: "arrow.right", style: .primary) {
            
        }
        .padding()
        .previewLayout(.sizeThatFits)
        CapsuleButton("Secondary", icon: "arrow.right", style: .secondary) {
            
        }
        .previewLayout(.sizeThatFits)
        CapsuleButton("Primary", icon: "arrow.right", style: .primary) {
            
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        CapsuleButton("Secondary", icon: "arrow.right", style: .secondary) {
            
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
