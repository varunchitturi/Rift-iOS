//
//  SwiftUIView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/21/21.
//

import SwiftUI

struct CapsuleButton: View {

    private var label: String
    private var icon: String?
    private let style: Style
    private var action: () -> Void
    
    init(_ label: String, icon: String? = nil, style: CapsuleButton.Style, action: @escaping () -> Void) {
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
        Button {
            action()
        } label: {
            labelView
        }
    }
    
    enum Style {
        case primary, secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color("Primary")
            case .secondary:
                return Color("Secondary")
            }
        }
        var foregroundColor: Color {
            switch self {
            case .primary:
                return Color("Secondary")
            case .secondary:
                return Color("Primary")
            }
        }
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
