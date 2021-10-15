//
//  UIToolbarDismiss.swift
//  Rift
//
//  Created by Varun Chitturi on 10/14/21.
//

import Foundation
import UIKit
import SwiftUI

class UIToolbarDismiss: UIToolbar {
    
    @Binding var isEditing: Bool
    
    init(editingState: Binding<Bool>) {
        self._isEditing = editingState
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: DrawingConstants.toolBarHeight))
        barStyle = .default
        isTranslucent = true
            
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(finishEditing))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setItems([spacer, doneButton], animated: false)
        isUserInteractionEnabled = true
    }
    
    @objc
    func finishEditing() {
        self.isEditing = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private struct DrawingConstants {
        static let toolBarHeight: CGFloat = 50
    }
}
