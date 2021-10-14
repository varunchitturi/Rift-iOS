//
//  UIPickerField.swift
//  UIPickerField
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

class UIPickerField: UITextField {
    
    @Binding var editingState: Bool
    
    init(isEditing: Binding<Bool>) {
        self._editingState = isEditing
        super.init(frame: .zero)
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: DrawingConstants.pickerToolBarHeight))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
            
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.finishEditing))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        toolBar.setItems([spacer, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
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
    
    private struct DrawingConstants {
           static let pickerToolBarHeight: CGFloat = 50
    }
       
}
