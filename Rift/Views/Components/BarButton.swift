//
//  SwiftUIView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/21/21.
//

import SwiftUI

struct BarButton: View {
    var text: String
    var iconSystemName: String?
    let type: type
    var action: () -> Void
    
    @ViewBuilder
    private var label: some View {
        HStack{
            Spacer()
            Text(text)
                .fontWeight(.bold)
            if iconSystemName != nil {
                Image(systemName: iconSystemName!)
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
        BarButton(text: "Primary", iconSystemName: "arrow.right", type: .primary) {
            
        }
            .previewLayout(.sizeThatFits)
        BarButton(text: "Secondary", iconSystemName: "arrow.right", type: .secondary) {
            
        }
            .previewLayout(.sizeThatFits)
    }
}
