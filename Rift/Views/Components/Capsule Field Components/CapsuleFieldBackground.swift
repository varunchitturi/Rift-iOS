//
//  CapsuleFieldBackground.swift
//  CapsuleFieldBackground
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct CapsuleFieldBackground: View {
    
    internal init(accentColor: Color = DrawingConstants.accentColor, isEditing: Binding<Bool>) {
        self.accentColor = accentColor
        self._isEditing = isEditing
    }
    
    let accentColor: Color
    @Binding var isEditing: Bool

    var body: some View {
        let backgroundRectangle =  RoundedRectangle(cornerRadius: .infinity)
            .fill(DrawingConstants.backgroundColor)
        let accentRectangle = RoundedRectangle(cornerRadius: .infinity).stroke()
            .fill(accentColor)
        ZStack {
            if isEditing {
                backgroundRectangle
                accentRectangle
            }
            else {
                backgroundRectangle
            }
        }
    }
}

#if DEBUG
struct CapsuleFieldBackground_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleFieldBackground(accentColor: DrawingConstants.accentColor, isEditing: .constant(true))
        CapsuleFieldBackground(accentColor: DrawingConstants.accentColor, isEditing: .constant(false))
    }
}
#endif
