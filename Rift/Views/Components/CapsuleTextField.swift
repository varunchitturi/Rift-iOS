//
//  RoundedTextField.swift
//  RoundedTextField
//
//  Created by Varun Chitturi on 8/23/21.
//

import SwiftUI


struct CapsuleTextField: View {

    
    let label: String?
    let accentColor: Color
    var icon: String?
    @Binding var text: String
    let isSecureStyle: Bool
    @State private var isSecure: Bool = false
    @Binding var isEditing: Bool
    
    private let configuration: (UITextField) -> ()
    
    init(_ label: String? = nil, text: Binding<String>, isEditing: Binding<Bool>, icon: String? = nil, accentColor: Color = DrawingConstants.accentColor, isSecureStyle: Bool = false, configuration: @escaping (UITextField) -> () = {_ in}) {
        self.label = label
        self.icon = icon
        self.accentColor = accentColor
        self._text = text
        self._isEditing = isEditing
        self.isSecureStyle = isSecureStyle
        if isSecureStyle {
            isSecure = true
        }
        self.configuration = configuration
    }
    
    var body: some View {
        VStack(alignment: .leading){
            if label != nil {
                CapsuleFieldLabel(label: label!, accentColor: accentColor, isEditing: $isEditing)
            }
            HStack {
                if icon != nil {
                    Image(systemName: icon!)
                        .foregroundColor(isEditing ? accentColor : DrawingConstants.foregroundColor)
                }
                
                    LegacyTextField(text: $text, isEditing: $isEditing) {textField in
                        textField.isSecureTextEntry = isSecure
                        textField.textColor = UIColor(DrawingConstants.textColor)
                        textField.keyboardType = .alphabet
                        configuration(textField)
                    }
                   
                if isSecureStyle {
                    (isSecure ? Image(systemName: "eye.slash.fill") : Image(systemName: "eye.fill"))
                        .foregroundColor(DrawingConstants.foregroundColor)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                }
                
            }
            .disabledStyle()
            .padding()
            .background(
                CapsuleFieldBackground(accentColor: accentColor, isEditing: $isEditing)
            )
            .fixedSize(horizontal: false, vertical: true)
          
        }
        
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Quartenary")
        static let accentColor = Color("Primary")
        static let textColor = Color("Tertiary")
    }

}

struct CapsuleTextField_Previews: PreviewProvider {
    @State private static var text = ""
    @State private static var isEditing = false
    
    static var previews: some View {
        CapsuleTextField("TextField", text: $text, isEditing: $isEditing, icon: "person.fill")
            .padding()
            .previewLayout(.sizeThatFits)
        CapsuleTextField("TextField", text: $text, isEditing: $isEditing, icon: "person.fill")
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
       
        
    }
}
