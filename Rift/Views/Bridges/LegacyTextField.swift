//
//  LegacyTextField.swift
//  LegacyTextField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct LegacyTextField: UIViewRepresentable {
    @Binding var isEditing: Bool
    @Binding var text: NSMutableAttributedString
    let autocompletionEnabled: Bool
    @Binding var completionPossibilities: [String]
    var autocompleteColor = Color("Quartenary")
    var textColor = Color("Tertiary")
    private let configuration: (UITextField) -> ()
    
    init(text: Binding<NSMutableAttributedString>, isEditing: Binding<Bool>, autocompletionEnabled: Bool = false, completionPossibilities: Binding<[String]> = .constant([]), configuration: @escaping (UITextField) -> () = {textfield in}) {
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
        textField.textColor = UIColor(textColor)
        return textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        if autocompletionEnabled {
            let query = text.string
            uiView.attributedText = createCompletionString(for: text)
            moveCaretToEndOfQuery(uiView, userQuery: query)
        }
        else {
            uiView.attributedText = text
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
    
    private func moveCaretToEndOfQuery(_ textField: UITextField, userQuery : String) {
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: userQuery.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    private func createCompletionString(for query: NSMutableAttributedString) -> NSMutableAttributedString {
        let query = query
        if let searchResult = searchCompletionPossibilities(for: query), query.string != "" {
            let searchResultSuffix = String(searchResult.suffix(searchResult.count - query.length))
            let queryLength = query.string.count
            let searchResultLength = searchResult.count
            query.append(NSMutableAttributedString(string: searchResultSuffix))
            query.addAttribute(.foregroundColor, value: UIColor(autocompleteColor), range: NSRange(location: queryLength ,length: searchResultLength - queryLength))
            return query
            
        }
        return query
    }
    
    private func searchCompletionPossibilities(for query: NSMutableAttributedString) -> String? {
        for possibility in completionPossibilities {
            if possibility.hasPrefix(query.string) {
                return possibility
            }
        }
        return nil
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing, autocompleteColor: UIColor(autocompleteColor), textColor: UIColor(textColor))
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool
        @Binding var text: NSMutableAttributedString
        var autocompleteColor: UIColor
        var textColor: UIColor
        
        init(text: Binding<NSMutableAttributedString>, isEditing: Binding<Bool>, autocompleteColor: UIColor, textColor: UIColor) {
            self._isEditing = isEditing
            self._text = text
            self.autocompleteColor = autocompleteColor
            self.textColor = textColor
        }
        
        private func retreiveNonAttributedText(for text: NSAttributedString?) -> NSMutableAttributedString {
            guard let text = text else {
                return NSMutableAttributedString(string: "")
            }
            let nonAttributedText = NSMutableAttributedString(string: "")
            for index in 0..<text.length {
                if text.attribute(.foregroundColor, at: index, effectiveRange: nil) as! UIColor? != autocompleteColor {
                    let nonAttributedCharacter = Array(text.string)[index]
                    nonAttributedText.append(NSMutableAttributedString(string: String(nonAttributedCharacter)))
                }
            }
            return nonAttributedText
        }
        
        
        @objc func textViewDidChange(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = self.retreiveNonAttributedText(for: textField.attributedText)
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isEditing = true
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text.addAttribute(.foregroundColor, value: self.textColor, range: NSRange(location: 0 ,length: self.text.length))
                textField.attributedText = self.text
                self.isEditing = false
            }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            DispatchQueue.main.async {
                textField.endEditing(false)
            }
            return true
        }
    }
}
