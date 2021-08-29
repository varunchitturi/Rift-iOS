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
        
        let pickerField = PickerField(description, options: options, selectionIndex: $selectionIndex, isEditing: $isEditing, tintColor: Color("Primary"))
           
        
        let dropDownIcon = Image(systemName: "chevron.down")
                                .padding(.trailing)
        let backgroundCapsule = Capsule()
            .fill(Color("Secondary"))
        let label = Text(label)
            .font(.caption)
            .fontWeight(.bold)
        
        VStack(alignment: .leading) {
            
            isEditing ? label.foregroundColor(Color("Primary")) : label.foregroundColor(Color("Tertiary"))

            HStack {
                isEditing ? pickerField
                    .modifier(pickerFieldConfig())
                    .foregroundColor(Color("Primary")) : pickerField
                    .modifier(pickerFieldConfig())
                    .foregroundColor(Color("Teritary"))
                    
                    
                Spacer()
                isEditing ? dropDownIcon
                    .foregroundColor(Color("Primary")) : dropDownIcon
                    .foregroundColor(Color("Tertiary"))
            }
            .padding()
            .background(
                ZStack {
                    backgroundCapsule
                    
                    if isEditing {
                        backgroundCapsule
                        Capsule()
                            .stroke()
                            .fill(Color("Primary"))
                    }
                }
                
            )
            .onTapGesture {
                pickerField.showPicker($isEditing)
            }
        }
    }
    
    private struct pickerFieldConfig: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}



struct CapsuleDropDown_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleDropDown("DropDown", description: "Pick an option",  options: ["Option 1", "Option 2", "Option 3"], selectionIndex: .constant(3))
            .padding()
    }
}
