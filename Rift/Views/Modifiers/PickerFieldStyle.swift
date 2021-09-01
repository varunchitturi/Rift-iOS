//
//  PickerFieldStyle.swift
//  PickerFieldStyle
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI


extension PickerField {
    mutating func foregroundColor(_ color: Color) -> some View {
        textColor = color
        return self
    }
}
