//
//  RoundedTextField.swift
//  RoundedTextField
//
//  Created by Varun Chitturi on 8/23/21.
//

import SwiftUI


struct CapsuleTextField: View {
    
    let label: String
    let accentColor: Color
    var icon: String?
    @Binding var text: String
    let isSecureStyle: Bool
    @State private var isSecure: Bool = false
    @State private var isEditing: Bool = false
    
    private let configuration: (UITextField) -> ()
    
    init(_ label: String = "", text: Binding<String>, icon: String? = nil, accentColor: Color = Color("AccentColor"), isSecureStyle: Bool = false, configuration: @escaping (UITextField) -> () = {_ in}) {
        self.label = label
        self.icon = icon
        self.accentColor = accentColor
        self._text = text
        self.isSecureStyle = isSecureStyle
        self.configuration = configuration
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(isEditing ? accentColor : Color("Tertiary"))
            
            HStack {
                if icon != nil {
                    Image(systemName: icon!)
                        .foregroundColor(isEditing ? accentColor : Color("Quartenary"))
                }
                LegacyTextField(text: $text, isEditing: $isEditing) {textField in
                    textField.isSecureTextEntry = isSecure
                    textField.clearsOnBeginEditing = false
                    textField.textColor = UIColor(Color("Tertiary"))
                    textField.keyboardType = .alphabet
                    configuration(textField)
                }
                if isSecureStyle {
                    (isSecure ? Image(systemName: "eye.slash.fill") : Image(systemName: "eye.fill"))
                        .foregroundColor(Color("Quartenary"))
                        .onTapGesture {
                            isSecure.toggle()
                        }
                }
                
            }
            .padding()
            .background(
                CapsuleFieldBackground(isEditing: $isEditing, accentColor: accentColor)
            )
        }
        
    }

}

struct CapsuleTextField_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleTextField("TextField", text: .constant(""),  icon: "person.fill")
            .padding()
            .previewLayout(.sizeThatFits)
        CapsuleTextField("TextField", text: .constant(""),  icon: "person.fill")
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
       
        
    }
}
