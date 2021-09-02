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
    
    private let configuration: (UITextField) -> ()
    
    init(text: Binding<String>, isEditing: Binding<Bool>, configuration: @escaping (UITextField) -> () = {textfield in}) {
        self._isEditing = isEditing
        self._text = text
        self.configuration = configuration
    }
    
    func makeUIView(context: Context) -> UILegacyTextField {
        let textField = UILegacyTextField()
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        textField.delegate = context.coordinator
        return textField
    }
    func updateUIView(_ uiView: UILegacyTextField, context: Context) {
        uiView.text = text
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        configuration(uiView)
        switch isEditing {
        case true: _ = uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
            
        }
        
    }
    
    static func customInputConfiguration(_ textField: UITextField){
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool
        @Binding var text: String
        
        init(text: Binding<String>, isEditing: Binding<Bool>) {
            self._isEditing = isEditing
            self._text = text
        }
        
        @objc
        func textViewDidChange(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
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
                self.isEditing = false
            }
            return true
        }
    }
}
