//
//  CapsuleAutoCompleteField.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import SwiftUI

struct CapsuleAutoCompleteField: View {
    @State private var isEditing: Bool = false
    @Binding var text: NSMutableAttributedString
    @Binding var autocompletePossibilites: [String]
    let minimumQueryLength: Int
    let accentColor: Color
    let label: String
    var body: some View {
        VStack(alignment: .leading) {
            CapsuleFieldLabel(label: label, accentColor: accentColor, isEditing: $isEditing)
            HStack {
                LegacyTextField(text: $text, isEditing: $isEditing, autocompletionEnabled: true, completionPossibilities: $autocompletePossibilites)
            }
            .disabledStyle()
            .padding()
            .background(
                CapsuleFieldBackground(accentColor: accentColor, isEditing: $isEditing)
            )
            .fixedSize(horizontal: false, vertical: true)
        }
    
    }
}

struct CapsuleAutoCompleteField_Previews: PreviewProvider {
    @State static var text = NSMutableAttributedString(string: "")
    @State static var autocompletePossibilites: [String] = ["Autocomplete", "Autofill"]

    static var previews: some View {
        CapsuleAutoCompleteField(text: $text, autocompletePossibilites: $autocompletePossibilites, minimumQueryLength: 3, accentColor: Color("Primary"), label: "Auto")
            .previewLayout(.sizeThatFits)
    }
}
