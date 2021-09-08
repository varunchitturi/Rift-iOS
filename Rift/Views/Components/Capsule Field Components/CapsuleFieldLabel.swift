//
//  CapsuleFieldLabel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct CapsuleFieldLabel: View {
    let label: String
    let accentColor: Color
    @Binding var isEditing: Bool
    var body: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(isEditing ? accentColor : DrawingConstants.textColor)
    }
    
    private struct DrawingConstants {
        static let textColor = Color("Tertiary")
    }
}

