//
//  CapsuleFieldLabel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct CapsuleFieldLabel: View {
    
    init(label: String, accentColor: Color = DrawingConstants.accentColor, isEditing: Binding<Bool>) {
        self.label = label
        self.accentColor = accentColor
        self._isEditing = isEditing
    }
    
    let label: String
    let accentColor: Color
    @Binding var isEditing: Bool
    
    var body: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(isEditing ? DrawingConstants.accentColor : DrawingConstants.foregroundColor)
            .lineLimit(1)
    }
}

