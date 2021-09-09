//
//  LegacyTextField.swift
//  LegacyTextField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI


// TODO: capture weak self for all async operations and make them sync for faster UI updates
struct LegacyTextField: UIViewRepresentable {
    @Binding var isEditing: Bool
    @Binding var text: String
    @Binding var options: [String]
    var textColor = DrawingConstants.defaultTextColor
    private let configuration: (UITextField) -> ()
    private let onEditingChanged: (String) -> ()
    private let onCommit: (String) -> ()
    
    init(text: Binding<String>, isEditing: Binding<Bool>, options: Binding<[String]> = .constant([]), onEditingChanged: @escaping (String) -> () = {_ in}, onCommit: @escaping (String) -> (), configuration: @escaping (UITextField) -> () = {_ in}) {
        self._isEditing = isEditing
        self._text = text
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self._options = options
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UILegacyTextField()
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        textField.delegate = context.coordinator
        textField.textColor = UIColor(textColor)
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        DispatchQueue.main.async {
            switch isEditing {
            case true:
                 _ = uiView.becomeFirstResponder()
            case false:
                uiView.resignFirstResponder()
            }
        }
           
        configuration(uiView)
        

        
    }
    
    static func customInputConfiguration(_ textField: UITextField){
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing, options: $options, textColor: UIColor(textColor), onEditingChanged: onEditingChanged, onCommit: onCommit)
    }
    
    private struct DrawingConstants {
        static let defaultTextColor = Color("Tertiary")
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool
        @Binding var text: String
        @Binding var options: [String]
        private let onEditingChanged: (String) -> ()
        private let onCommit: (String) -> ()
        var textColor: UIColor
        
        init(text: Binding<String>, isEditing: Binding<Bool>, options: Binding<[String]>, textColor: UIColor, onEditingChanged: @escaping (String) -> (), onCommit: @escaping (String) -> ()) {
            self._isEditing = isEditing
            self._text = text
            self._options = options
            self.textColor = textColor
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
            
        }

        
        
        @objc func textViewDidChange(_ textField: UITextField) {
            let textFieldText = textField.text ?? ""
            onEditingChanged(textFieldText)
            self.text = textFieldText
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {[weak self] in
                self?.isEditing = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {[weak self] in
                self?.isEditing = false
            }
            
            
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(false)
            onCommit(textField.text ?? "")
            return true
        }
    }
}
