//
//  CapsuleFieldModularButton.swift
//  CapsuleFieldModularButton
//
//  Created by Varun Chitturi on 9/7/21.
//

import SwiftUI

struct CapsuleFieldModularButton: View {
    
    var label: String
    var description: String
    var icon: String?
    @Binding var text: String?
    private var action: (() -> Void)?
    
    init(_ label: String, description: String, text: Binding<String?>, icon: String? = nil, action: (() -> Void)? = nil) {
        self.action = action
        self._text = text
        self.label = label
        self.description = description
        self.icon = icon
    }
    
    @ViewBuilder
    private var labelView: some View {
        VStack(alignment: .leading) {
            CapsuleFieldLabel(label: label, accentColor: DrawingConstants.foregroundColor, isEditing: .constant(false))
            HStack {
                Text(text ?? description)
                    .foregroundColor(text != nil ? DrawingConstants.foregroundColor : DrawingConstants.disabledColor)
                    .padding(.leading)
                Spacer()
                if icon != nil {
                    Image(systemName: icon!)
                        .foregroundColor(DrawingConstants.foregroundColor)
                        .padding(.trailing)
                }
            }
            .disabledStyle()
            .padding()
            .background(
                CapsuleFieldBackground(accentColor: DrawingConstants.foregroundColor, isEditing: .constant(false))
            )
        }
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
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let disabledColor = Color("Quartenary")
    }
}

struct CapsuleFieldModularButton_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleFieldModularButton("Button", description: "A Button", text: .constant("Button"))
    }
}
