//
//  SwiftUIView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/21/21.
//

import SwiftUI

struct CapsuleButton: View {

    private var description: String
    private var icon: String?
    private let style: Style
    private var action: () -> Void
    
    init(description: String, icon: String? = nil, style: CapsuleButton.Style, action: @escaping () -> Void) {
        self.description = description
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    @ViewBuilder
    private var label: some View {
        HStack{
            Spacer()
            Text(description)
                .fontWeight(.bold)
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
            label
        }
    }
    
    enum Style {
        case primary, secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color("Primary")
            case .secondary:
                return .white
            }
        }
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .white
            case .secondary:
                return Color("Primary")
            }
        }
    }
    
    
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(description: "Primary", icon: "arrow.right", style: .primary) {
            
        }
            .previewLayout(.sizeThatFits)
        CapsuleButton(description: "Secondary", icon: "arrow.right", style: .secondary) {
            
        }
            .previewLayout(.sizeThatFits)
    }
}
