//
//  LegacyTextField.swift
//  LegacyTextField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI


// TODO: capture weak self for all async operations and make them sync for faster UI updates
// TODO: allow carrot to be moved to query text
struct LegacyTextField: UIViewRepresentable {
    @Binding var isEditing: Bool
    @Binding var text: NSMutableAttributedString
    @State private var query: String = ""
    let autocompletionEnabled: Bool
    @Binding var completionPossibilities: [String]
    var autocompleteColor = Color("Quartenary")
    var textColor = Color("Tertiary")
    private let configuration: (UITextField) -> ()
    
    init(text: Binding<NSMutableAttributedString>, isEditing: Binding<Bool>, autocompletionEnabled: Bool = false, completionPossibilities: Binding<[String]> = .constant([]), configuration: @escaping (UITextField) -> () = {textfield in}) {
        self._isEditing = isEditing
        self._text = text
        self.query = text.wrappedValue.string
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
        uiView.attributedText = text
        if autocompletionEnabled {
            uiView.setTypingColor(UIColor(textColor))
            uiView.moveCaret(to: query.count)
            
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, query: $query, isEditing: $isEditing, autocompleteColor: UIColor(autocompleteColor), completionPossibilities: $completionPossibilities, textColor: UIColor(textColor))
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var isEditing: Bool
        @Binding var text: NSMutableAttributedString
        @Binding var query: String
        @Binding var completionPossibilities: [String]
        var autocompleteColor: UIColor
        var textColor: UIColor
        
        init(text: Binding<NSMutableAttributedString>, query: Binding<String>, isEditing: Binding<Bool>, autocompleteColor: UIColor, completionPossibilities: Binding<[String]>, textColor: UIColor) {
            self._isEditing = isEditing
            self._text = text
            self._query = query
            self._completionPossibilities = completionPossibilities
            self.autocompleteColor = autocompleteColor
            self.textColor = textColor
        }

        
        
        private func retreiveNonAutocompleteText(for text: NSAttributedString?) -> String {
            guard let text = text else {
                return ""
            }
            let query = NSMutableAttributedString(string: "")
            for index in 0..<text.length {
                if text.attribute(.foregroundColor, at: index, effectiveRange: nil) as! UIColor? != autocompleteColor {
                    let nonAttributedCharacter = Array(text.string)[index]
                    query.append(NSMutableAttributedString(string: String(nonAttributedCharacter)))
                }
            }
            return query.string
        }
        
        private func createCompletionString(for query: NSMutableAttributedString) -> NSMutableAttributedString {

            let queryLength = query.string.count
            query.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0 ,length: queryLength))
            if let searchResult = searchCompletionPossibilities(for: query.string), query.string != "" {
            
                let searchResultSuffix = String(searchResult.suffix(searchResult.count - query.length))
               
                let searchResultSuffixLength = searchResultSuffix.count
                query.append(NSMutableAttributedString(string: searchResultSuffix))
                query.addAttribute(.foregroundColor, value: autocompleteColor, range: NSRange(location: queryLength ,length: searchResultSuffixLength))
            }
            return query
        }
        
        private func createCompletionString(for query: String) -> NSMutableAttributedString {
            createCompletionString(for: NSMutableAttributedString(string: query))
        }
        
        private func convertToMutableAttributedString(for text: NSAttributedString?) -> NSMutableAttributedString {
            NSMutableAttributedString(attributedString: text ?? NSAttributedString(string: ""))
        }
        // TODO: move below funciton to extensions
        private func resetedTextAttributes(for text: NSAttributedString?) -> NSMutableAttributedString {
            guard let text = text else {
                return NSMutableAttributedString(string: "")
            }
            let attributedString = NSMutableAttributedString(attributedString: text)
            attributedString.addAttribute(.foregroundColor, value: self.textColor, range: NSRange(location: 0 ,length: attributedString.length))
            return attributedString
        }
        
        private func searchCompletionPossibilities(for query: String) -> String? {
            for possibility in completionPossibilities {
                if possibility.hasPrefix(query) {
                    return possibility
                }
            }
            return nil
        }
        
        
        @objc func textViewDidChange(_ textField: UITextField) {
            DispatchQueue.main.async {[weak self] in
                if let _self = self {
                    _self.isEditing = true
                    if _self.query == "" {
                        textField.textColor = _self.textColor
                    }
                    let query = _self.retreiveNonAutocompleteText(for: textField.attributedText)
                    _self.query = query
                    _self.text = _self.createCompletionString(for: query)
                }
                
               
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {[weak self] in
                if let _self = self {
                    _self.isEditing = true
                    _self.query = _self.text.string
                    
                }
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {[weak self] in
                if let resetedAttributedText = self?.resetedTextAttributes(for: self?.text) {
                    self?.text = resetedAttributedText
                }
                if let text = self?.text {
                    textField.attributedText = text
                }
                self?.isEditing = false
            }
            
            
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(false)

            return true
        }
    }
}
