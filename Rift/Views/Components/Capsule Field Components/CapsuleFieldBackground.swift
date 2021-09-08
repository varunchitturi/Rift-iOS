//
//  CapsuleFieldBackground.swift
//  CapsuleFieldBackground
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct CapsuleFieldBackground: View {
    var accentColor: Color
    @Binding var isEditing: Bool

    var body: some View {
        let backgroundRectangle =  RoundedRectangle(cornerRadius: .infinity)
            .fill(DrawingConstants.secondaryColor)
        let accentRectangle = RoundedRectangle(cornerRadius: .infinity).stroke()
            .fill(accentColor)
        ZStack {
            backgroundRectangle
            if isEditing {
                accentRectangle
            }
        }
    }
    private struct DrawingConstants {
        static let primaryColor = Color("Primary")
        static let secondaryColor = Color("Secondary")
    }
}


struct CapsuleFieldBackground_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleFieldBackground(accentColor: Color("Primary"), isEditing: .constant(true))
        CapsuleFieldBackground(accentColor: Color("Primary"), isEditing: .constant(false))
    }
}
