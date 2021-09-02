//
//  DropDown.swift
//  Rift
//
//  Created by Varun Chitturi on 8/24/21.
//

import SwiftUI
import UIKit

struct CapsuleDropDown: View {

    @State private var isEditing: Bool = false
    @Binding var selectionIndex: Int?
    var accentColor: Color
    
    var selection: String? {
        selectionIndex != nil ? options[selectionIndex!] : nil
    }
    private var options: [String]
    private var label: String
    private var description: String
    
    init(_ label: String, description: String, options: [String], selectionIndex: Binding<Int?>, accentColor: Color = Color("AccentColor")) {
        self.options = options
        self.label = label
        self.description = description
        self._selectionIndex = selectionIndex
        self.accentColor = accentColor
    }
    
    var body: some View {
        var pickerField = PickerField(options: options, placeholder: description, selectionIndex: $selectionIndex, isEditing: $isEditing)
        let dropDownIcon = Image(systemName: "chevron.down")
                                .padding(.trailing)
        
        VStack(alignment: .leading) {
            CapsuleFieldLabel(label: label, accentColor: accentColor, isEditing: $isEditing)
            HStack {
                pickerField
                    .foregroundColor(Color("Tertiary"))
                    .padding(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                dropDownIcon
            }
            .disabledStyle()
            .padding()
            .background(
                CapsuleFieldBackground(accentColor: accentColor, isEditing: $isEditing)
            )
            .onTapGesture {
                isEditing = true
            }
            
        }
        .foregroundColor(isEditing ? Color("Primary") : Color("Tertiary"))
    }
    
}



struct CapsuleDropDown_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleDropDown("DropDown", description: "Pick an option", options: ["Option 1", "Option 2", "Option 3"], selectionIndex: .constant(nil))
    }
}
