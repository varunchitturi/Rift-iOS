//
//  RoundedTextField.swift
//  RoundedTextField
//
//  Created by Varun Chitturi on 8/23/21.
//

import SwiftUI


struct CapsuleTextField: View {
    
    private let label: String
    private let accentColor: Color
    private var icon: String?
    @Binding var text: String
    @State private var isEditing: Bool = false
    
    init(_ label: String = "", text: Binding<String>, icon: String? = nil, accentColor: Color = .blue) {
        self.label = label
        self.icon = icon
        self.accentColor = accentColor
        self._text = text
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
                TextField("", text: $text) {isEditing in
                    self.isEditing = isEditing
                }
            }
            .padding()
            .background(
                ZStack {
                    let backgroundRectangle =  RoundedRectangle(cornerRadius: .infinity)
                        .fill(Color("Secondary"))
                    let accentRectangle =  RoundedRectangle(cornerRadius: .infinity)
                        .stroke()
                        .fill(accentColor)
                    if isEditing {
                        backgroundRectangle
                        accentRectangle
                    }
                    else {
                       backgroundRectangle
                    }
                   
                }
                
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
