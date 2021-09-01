//
//  PickerFieldBridge.swift
//  PickerFieldBridge
//
//  Created by Varun Chitturi on 8/25/21.
//

import SwiftUI

struct PickerField : UIViewRepresentable {
    
    init(options: [String], placeholder: String, selectionIndex: Binding<Int?>, isEditing: Binding<Bool>) {
        self.options = options
        self.placeholder = placeholder
        self._selectionIndex = selectionIndex
        self._isEditing = isEditing
        self.pickerField = UIPickerField(isEditing: isEditing)
    }
    

    var options : [String]
    var placeholder : String
    var textColor: Color? {
        get {
            pickerField.textColor != nil ? Color(pickerField.textColor!) : nil
        }
        
        set {
            pickerField.textColor = newValue != nil ? UIColor(newValue!) : nil
        }
    }
 
    @Binding var selectionIndex : Int?
    @Binding var isEditing: Bool

    var selection: String? {
        selectionIndex != nil ? options[selectionIndex!] : nil
    }

    private let pickerField: UIPickerField
    private let picker = UIPickerView()
    
    
    func makeCoordinator() -> PickerField.Coordinator {
        Coordinator(textfield: self)
    }

    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        pickerField.placeholder = placeholder
        pickerField.inputView = picker
        pickerField.delegate = context.coordinator
        return pickerField
    }
    

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        uiView.text = selection
        if isEditing {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }
        else {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate {

        private let parent : PickerField

        init(textfield : PickerField) {
            self.parent = textfield
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.options.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.options[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selectionIndex = row
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.selectionIndex = self.parent.picker.selectedRow(inComponent: 0)
            DispatchQueue.main.async {
                self.parent.isEditing = false
            }
        }
        
    }
}
