//
//  UITextFieldExtensions.swift
//  UITextFieldExtensions
//
//  Created by Varun Chitturi on 9/3/21.
//

import SwiftUI



extension UITextField {
    func moveCaret(to index: Int) {
        if let newPosition = self.position(from: self.beginningOfDocument, offset: index) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func setTypingColor(_ color: UIColor) {
        let attributedText = self.attributedText
        self.textColor = color
        self.attributedText = attributedText
    }
}
