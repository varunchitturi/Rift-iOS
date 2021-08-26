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
    private let pickerField: UIPickerField
    
    
    init(_ label: String, options: [String], selectionIndex: Binding<Int?>, isEditing: Binding<Bool>) {
        self.label = label
        self._selectionIndex = selectionIndex
        self.options = options
        self._isEditing = isEditing
        self.pickerField = UIPickerField(options: options, selectionIndex: selectionIndex, isEditing: isEditing)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        
        pickerField.placeholder = label
        return pickerField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        if let index = selectionIndex {
            uiView.text = options[index]
        } else {
            uiView.text = label
        }
    }
    func showPicker(_ show: Binding<Bool>) {
        if !show.wrappedValue {
            show.wrappedValue = true
            pickerField.becomeFirstResponder()
        }
    }
}


