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
    let autocompletionEnabled: Bool
    @Binding var completionPossibilities: [String]
    private let configuration: (UITextField) -> ()
    
    init(text: Binding<String>, isEditing: Binding<Bool>, autocompletionEnabled: Bool = false, completionPossibilities: Binding<[String]> = .constant([]), configuration: @escaping (UITextField) -> () = {textfield in}) {
        self._isEditing = isEditing
        self._text = text
        self.configuration = configuration
        self._completionPossibilities = completionPossibilities
        self.autocompletionEnabled = autocompletionEnabled
        
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UILegacyTextField()
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        textField.delegate = context.coordinator
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        print("update")
        if autocompletionEnabled {
            if let searchResult = searchCompletionPossibilities(for: text), text != "" {
                let attributedString = NSMutableAttributedString(string: text+String(searchResult.suffix(searchResult.count - text.count)))
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(Color("Quartenary")), range: NSRange(location: text.count ,length: searchResult.count - text.count))
                uiView.attributedText = attributedString
                moveCaretToEndOfQuery(uiView, userQuery: text)
                
            }
            else {
                uiView.text = text
            }
        }
        else {
            uiView.text = text
        }
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        switch isEditing {
        case true: _ = uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
        configuration(uiView)
    }
    
    static func customInputConfiguration(_ textField: UITextField){
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    func moveCaretToEndOfQuery(_ textField: UITextField, userQuery : String) {
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: userQuery.count) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            let selectedRange: UITextRange? = textField.selectedTextRange
            textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
        }
    
    func searchCompletionPossibilities(for query: String) -> String? {
        for possibility in completionPossibilities {
            if possibility.hasPrefix(query) {
                return possibility
            }
        }
        return nil
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
                
                print(textField.text)
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
