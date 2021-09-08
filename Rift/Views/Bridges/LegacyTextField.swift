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
    
    init(text: Binding<String>, isEditing: Binding<Bool>, options: Binding<[String]> = .constant([]), configuration: @escaping (UITextField) -> () = {textfield in}) {
        self._isEditing = isEditing
        self._text = text
        self.configuration = configuration
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
            switch isEditing {
            case true:
                DispatchQueue.main.async { _ = uiView.becomeFirstResponder() }
            case false:
                DispatchQueue.main.async { uiView.resignFirstResponder() }
        }
           
        configuration(uiView)
        

        
    }
    
    static func customInputConfiguration(_ textField: UITextField){
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing, options: $options, textColor: UIColor(textColor))
    }
    
    private struct DrawingConstants {
        static let defaultTextColor = Color("Tertiary")
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool
        @Binding var text: String
        @Binding var options: [String]
        var textColor: UIColor
        
        init(text: Binding<String>, isEditing: Binding<Bool>, options: Binding<[String]>, textColor: UIColor) {
            self._isEditing = isEditing
            self._text = text
            self._options = options
            self.textColor = textColor
            
        }

        
        
        @objc func textViewDidChange(_ textField: UITextField) {
            let textFieldText = textField.text ?? ""
            let querySuggestions = options.filter { $0.lowercased().hasPrefix(textFieldText.lowercased())}
            if querySuggestions.count > 0 && querySuggestions[0] != "" {
                textField.setMarkedText(querySuggestions[0], selectedRange: NSMakeRange(textFieldText.count, querySuggestions[0].count))
            }
            
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
            return true
        }
    }
}
