//
//  SwiftUIView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/21/21.
//

import SwiftUI

struct CapsuleButton: View {
    var description: String
    var icon: String?
    let type: type
    var action: () -> Void
    
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
        .foregroundColor(self.type.foregroundColor)
        .background(
                Capsule()
                    .fill(self.type.backgroundColor)
        )
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            label
        }
    }
    
    enum type {
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
        CapsuleButton(description: "Primary", icon: "arrow.right", type: .primary) {
            
        }
            .previewLayout(.sizeThatFits)
        CapsuleButton(description: "Secondary", icon: "arrow.right", type: .secondary) {
            
        }
            .previewLayout(.sizeThatFits)
    }
}
