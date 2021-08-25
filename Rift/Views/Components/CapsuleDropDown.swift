//
//  DropDown.swift
//  Rift
//
//  Created by Varun Chitturi on 8/24/21.
//

import SwiftUI

struct CapsuleDropDown: View {
    private var options: [String]
    @Binding private var selection: String?
    @State private var isPresented: Bool = false
    private var label: String
    private var description: String
    
    init(options: [String], selection: Binding<String?>, label: String, description: String) {
        self.options = options
        self._selection = selection
        self.label = label
        self.description = description
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color("Tertiary"))
            
            Button {
                isPresented = true
            } label: {
                HStack {
                    Text(selection ?? description)
                        .foregroundColor(Color("Tertiary"))
                        .fontWeight(.semibold)
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
                
            }.sheet(isPresented: $isPresented) {
                
            }
        }
        
    }
            
}

struct CapsuleDropDown_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleDropDown(options: ["Option 1", "Option 2", "Option 3"], selection: .constant("Defult Selection"), label: "DropDown", description: "Make a selection")
            .padding()
    }
}
