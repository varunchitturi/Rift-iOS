//
//  UIPickerField.swift
//  UIPickerField
//
//  Created by Varun Chitturi on 8/25/21.
//

import SwiftUI


class UIPickerField: UITextField {
    private var options: [String]
    @Binding var selectionIndex: Int?
    @Binding var editingState: Bool
    init(options: [String], selectionIndex: Binding<Int?>, isEditing: Binding<Bool>, tintColor: Color) {
        self.options = options
        self._selectionIndex = selectionIndex
        self._editingState = isEditing
        super.init(frame: .zero)
        self.inputView = picker
        self.tintColor = UIColor(tintColor)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: DrawingConstants.pickerToolBarHeight))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
            
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.finishEditing))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spacer, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc
    private func finishEditing() {
        self.selectionIndex = self.picker.selectedRow(inComponent: 0)
        editingState = false
        self.resignFirstResponder()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            false
    }
        
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
    
    private struct DrawingConstants {
        static let pickerToolBarHeight: CGFloat = 50
    }
    
}

extension UIPickerField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionIndex = row
    }
    
    
}
