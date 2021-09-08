//
//  DistrictSearchView.swift
//  DistrictSearchView
//
//  Created by Varun Chitturi on 9/7/21.
//

import SwiftUI

struct DistrictSearchView: View {
    @State private var searchQuery: String = ""
    @State private var isSearching: Bool = false
    var body: some View {
        VStack {
            HStack {
                CapsuleTextField(text: $searchQuery, isEditing: $isSearching, icon: "magnifyingglass")
                if isSearching {
                    Button {
                        isSearching = false
                    } label: {
                        withAnimation {
                            Text("Cancel")
                        }

                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            
        }
    }
}

struct DistrictSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DistrictSearchView()
    }
}
