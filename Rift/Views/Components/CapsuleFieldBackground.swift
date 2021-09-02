//
//  CapsuleFieldBackground.swift
//  CapsuleFieldBackground
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct CapsuleFieldBackground: View {
    @Binding var isEditing: Bool
    var accentColor: Color
    var body: some View {
        let backgroundRectangle =  RoundedRectangle(cornerRadius: .infinity)
            .fill(Color("Secondary"))
        let accentRectangle = RoundedRectangle(cornerRadius: .infinity).stroke()
            .fill(accentColor)
        ZStack {
           
            backgroundRectangle
            if isEditing {
                accentRectangle
            }
        }
    }
}

struct CapsuleFieldBackground_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleFieldBackground(isEditing: .constant(true), accentColor: Color("Primary"))
        CapsuleFieldBackground(isEditing: .constant(false), accentColor: Color("Primary"))
    }
}
