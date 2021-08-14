//
//  DropDownView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/10/21.
//

import SwiftUI

struct DropDownView: View {
    let items: [String]
    let title: String
    @Binding var isExpanded: Bool
    @Binding var selectedItem: String
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .foregroundColor(Color("Tertiary"))
            DisclosureGroup(title, isExpanded: $isExpanded) {
                VStack {
                    ForEach(items, id: \.self) {
                        Text($0)
                            .font(.body)
                    }
                }
                .padding()
            }
            .foregroundColor(Color("Tertiary"))
            .padding()
            .background(Color("Secondary"))
            .cornerRadius(8)
            .accentColor(Color("Tertiary"))

        }
        
               
        
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView(items: ["item1", "item2", "item3"], title: "DropDown",
                     isExpanded: .constant(false), selectedItem: .constant("Choose Item"))
            .previewLayout(.sizeThatFits)
    }
}
