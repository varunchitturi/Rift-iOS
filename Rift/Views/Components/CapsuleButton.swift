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
        .environment(\.colorScheme, .light)
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
            .disableable()
        }
        else {
            labelView
                .disableable()
        }
    }
    
    enum Style {
        case primary, secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return DrawingConstants.accentColor
            case .secondary:
                return DrawingConstants.foregroundColor
            }
        }
        var foregroundColor: Color {
            switch self {
            case .primary:
                return DrawingConstants.foregroundColor
            case .secondary:
                return DrawingConstants.accentColor
            }
        }
    }
}

#if DEBUG
struct CapsuleButton_Previews: PreviewProvider {
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
#endif
