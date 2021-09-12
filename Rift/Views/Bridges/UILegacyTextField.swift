//
//  UILegacyTextField.swift
//  UILegacyTextField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

class UILegacyTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return didBecomeFirstResponder
    }
}
