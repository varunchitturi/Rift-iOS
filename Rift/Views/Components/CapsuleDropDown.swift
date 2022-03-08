//
//  DropDown.swift
//  Rift
//
//  Created by Varun Chitturi on 8/24/21.
//

import SwiftUI
import UIKit

/// A dropdown button that actives a picker view when pressed with a capsule-like background
struct CapsuleDropDown: View {

    @Binding var isEditing: Bool
    @Binding var selectionIndex: Int?
    var accentColor: Color
    
    var selection: String? {
        selectionIndex != nil ? options[selectionIndex!] : nil
    }
    private var options: [String]
    private var label: String?
    private var description: String
    
    init(_ label: String? = nil, description: String, options: [String], selectionIndex: Binding<Int?>, isEditing: Binding<Bool>, accentColor: Color = DrawingConstants.accentColor) {
        self.options = options
        self.label = label
        self.description = description
        self._selectionIndex = selectionIndex
        self.accentColor = accentColor
        self._isEditing = isEditing
    }
    
    var body: some View {
        var pickerField = PickerField(options: options, placeholder: description, selectionIndex: $selectionIndex, isEditing: $isEditing)
        let dropDownIcon = Image(systemName: "chevron.down")
                                .padding(.trailing)
        
        VStack(alignment: .leading) {
            if label != nil {
                CapsuleFieldLabel(label: label!, accentColor: accentColor, isEditing: $isEditing)
            }
            HStack {
                pickerField
                    .foregroundColor(DrawingConstants.foregroundColor)
                    .padding(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                dropDownIcon
            }
            .disableable()
            .padding()
            .background(
                CapsuleFieldBackground(accentColor: accentColor, isEditing: $isEditing)
            )
            .onTapGesture {
                isEditing = true
            }
            
        }
        .foregroundColor(isEditing ? accentColor : DrawingConstants.foregroundColor)
    }
    
    
}


#if DEBUG
struct CapsuleDropDown_Previews: PreviewProvider {
    @State private static var isEditing = false
    static var previews: some View {
        CapsuleDropDown("DropDown", description: "Pick an option", options: ["Option 1", "Option 2", "Option 3"], selectionIndex: .constant(nil), isEditing: $isEditing)
    }
}
#endif
