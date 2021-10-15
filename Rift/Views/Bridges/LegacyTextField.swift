//
//  LegacyTextField.swift
//  LegacyTextField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI


struct LegacyTextField: UIViewRepresentable {
    @Binding var isEditing: Bool
    @Binding var text: String
    @Binding var options: [String]
    var textColor = DrawingConstants.defaultTextColor
    private let configuration: (UITextField) -> ()
    private let onEditingChanged: (String) -> ()
    private let onCommit: (String) -> ()
    private let inputType: InputType
    
    // TODO: make the organization of these UIKit bridges the same way. The structure of this should be same as picker field
    // TODO: make a better API for this. Shouldn't have options
    init(text: Binding<String>, isEditing: Binding<Bool>, options: Binding<[String]> = .constant([]), inputType: InputType = .default, onEditingChanged: @escaping (String) -> () = {_ in}, onCommit: @escaping (String) -> (), configuration: @escaping (UITextField) -> () = {_ in}) {
        self._isEditing = isEditing
        self._text = text
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self._options = options
        self.inputType = inputType
    }
    
    enum InputType {
        case `default`
        case number
        case decimal
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UILegacyTextField()
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        textField.delegate = context.coordinator
        textField.textColor = UIColor(textColor)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        switch inputType {
        case .number, .decimal:
            textField.inputAccessoryView = UIToolbarDismiss(editingState: $isEditing)
        default:
            textField.inputAccessoryView = nil
        }
        
        switch inputType {
        case .`default`:
            textField.keyboardType = .default
        case .number:
            textField.keyboardType = .numberPad
        case .decimal:
            textField.keyboardType = .decimalPad
        }
        
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        configuration(uiView)
        uiView.text = text
        DispatchQueue.main.async {
            switch isEditing {
            case true:
                _ = uiView.becomeFirstResponder()
            case false:
                uiView.resignFirstResponder()
                
            }
        }
    }
    
    static func customInputConfiguration(_ textField: UITextField){
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing, options: $options, inputType: inputType, textColor: UIColor(textColor), onEditingChanged: onEditingChanged, onCommit: onCommit)
    }
    
    private struct DrawingConstants {
        static let defaultTextColor = Color("Tertiary")
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool
        @Binding var text: String
        @Binding var options: [String]
        private let onEditingChanged: (String) -> ()
        private let onCommit: (String) -> ()
        private let inputType: InputType
        var textColor: UIColor
        
        init(text: Binding<String>, isEditing: Binding<Bool>, options: Binding<[String]>, inputType: InputType, textColor: UIColor, onEditingChanged: @escaping (String) -> (), onCommit: @escaping (String) -> ()) {
            self._isEditing = isEditing
            self._text = text
            self._options = options
            self.inputType = inputType
            self.textColor = textColor
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
            
        }
        
        @objc
        func textViewDidChange(_ textField: UITextField) {
            let textFieldText = textField.text ?? ""
            self.text = textFieldText
            DispatchQueue.main.async {
                self.onEditingChanged(textFieldText)
            }
          
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            switch inputType {
            case .default:
                return true
            case .number, .decimal:
                if textField.text != "" || string != "" {
                    let newValue = (textField.text ?? "") + string
                    return inputType == .number ? Int(newValue) != nil : Double(newValue) != nil
                }
                return true
            }
           
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isEditing = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isEditing = false
            }
            
            
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            DispatchQueue.main.async {
                textField.endEditing(true)
                self.onCommit(textField.text ?? "")
            }
            return true
        }
    }
}
