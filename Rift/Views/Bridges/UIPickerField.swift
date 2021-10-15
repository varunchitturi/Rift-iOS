//
//  UIPickerField.swift
//  UIPickerField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

class UIPickerField: UITextField {
    
    @Binding var editingState: Bool
    
    init(editingState: Binding<Bool>) {
        self._editingState = editingState
        super.init(frame: .zero)

        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.inputAccessoryView = UIToolbarDismiss(editingState: $editingState)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func finishEditing() {
        editingState = false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .null
    }
    
}
