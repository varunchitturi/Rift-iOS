//
//  RoundedTextField.swift
//  RoundedTextField
//
//  Created by Varun Chitturi on 8/23/21.
//

import SwiftUI


struct RoundedTextField: View {
    let label: String
    let accentColor: Color
    var icon: String?
    @Binding var text: String
    @State var isEditing: Bool = false
    var body: some View {
        VStack(alignment: .leading){
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(isEditing ? accentColor : Color("Tertiary"))
            
            HStack {
                if icon != nil {
                    Image(systemName: icon!)
                        .foregroundColor(isEditing ? accentColor : Color("Tertiary"))
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
    
    init(text: Binding<String>, label: String = "", icon: String? = nil, accentColor: Color = .blue) {
        self.label = label
        self.icon = icon
        self.accentColor = accentColor
        self._text = text
    }
}



struct RoundedTextField_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTextField(text: .constant(""), label: "Username", icon: "person")
            .previewLayout(.sizeThatFits)
        .padding()
        
    }
}
