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
    
    var selection: String? {
        selectionIndex != nil ? options[selectionIndex!] : nil
    }
    private var options: [String]
    private var label: String
    private var description: String
    
    init(_ label: String, description: String, options: [String], selectionIndex: Binding<Int?>) {
        self.options = options
        self.label = label
        self.description = description
        self._selectionIndex = selectionIndex
    }
    
    var body: some View {
        var pickerField = PickerField(options: options, placeholder: description, selectionIndex: $selectionIndex, isEditing: $isEditing)
        let dropDownIcon = Image(systemName: "chevron.down")
                                .padding(.trailing)
        let backgroundCapsule = Capsule()
            .fill(Color("Secondary"))
        let label = Text(label)
            .font(.caption)
            .fontWeight(.bold)
        
        VStack(alignment: .leading) {
            label
            HStack {
                pickerField
                    .foregroundColor(Color("Tertiary"))
                    .padding(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                dropDownIcon
            }
            .padding()
            .background(
                ZStack {
                    backgroundCapsule
                    if isEditing {
                        Capsule()
                            .stroke()
                            .fill(Color("Primary"))
                    }
                }
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
