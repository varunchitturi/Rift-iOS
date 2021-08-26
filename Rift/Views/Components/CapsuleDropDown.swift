//
//  DropDown.swift
//  Rift
//
//  Created by Varun Chitturi on 8/24/21.
//

import SwiftUI
import UIKit

struct CapsuleDropDown: View {
    
    // TODO: Handle case when CapsuleDropDown is not in a form
    @State private var isEditing: Bool = false
    @Binding var selectionIndex: Int?
    private var options: [String]
    private var label: String
    private var description: String
    
    var selection: String? {
        selectionIndex != nil ? options[selectionIndex!] : nil
    }
    
    init(_ label: String, description: String, options: [String], selectionIndex: Binding<Int?>) {
        self.options = options
        self.label = label
        self.description = description
        self._selectionIndex = selectionIndex
    }
    
    var body: some View {
        let pickerField = PickerField(description, options: options, selectionIndex: $selectionIndex, isEditing: $isEditing)
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color("Tertiary"))
            
            
            HStack {
                pickerField
                    .padding(.leading)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color("Tertiary"))
                    .padding(.trailing)
            }
            .padding()
            .background(
                Capsule()
                    .fill(Color("Secondary"))
            )
            .onTapGesture {
                pickerField.showPicker($isEditing)
            }
        }
    }
    
}

struct CapsuleDropDown_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleDropDown("DropDown", description: "Pick an option",  options: ["Option 1", "Option 2", "Option 3"], selectionIndex: .constant(3))
            .padding()
    }
}
