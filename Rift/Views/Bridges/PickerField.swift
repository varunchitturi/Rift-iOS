//
//  PickerFieldBridge.swift
//  PickerFieldBridge
//
//  Created by Varun Chitturi on 8/25/21.
//

import SwiftUI

struct PickerField: UIViewRepresentable {
    
    @Binding var selectionIndex: Int?
    @Binding var isEditing: Bool
    
    private var options: [String]
    private let label: String
    private let tintColor: Color
    
    init(_ label: String, options: [String], selectionIndex: Binding<Int?>, isEditing: Binding<Bool>, tintColor: Color) {
        self.label = label
        self._selectionIndex = selectionIndex
        self.options = options
        self._isEditing = isEditing
        self.tintColor = tintColor
    }
    
    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        let pickerField = UIPickerField(options: options, selectionIndex: $selectionIndex, isEditing: $isEditing, tintColor: tintColor)
        pickerField.placeholder = label
        return pickerField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        if let index = selectionIndex {
            uiView.text = options[index]
        } else {
            uiView.text = label
        }
        if isEditing {
            uiView.becomeFirstResponder()
        }
    }
}


