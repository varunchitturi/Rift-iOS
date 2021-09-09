//
//  DistrictSearchView.swift
//  DistrictSearchView
//
//  Created by Varun Chitturi on 9/7/21.
//

import SwiftUI

struct DistrictSearchView: View {
    @ObservedObject var localeViewModel: LocaleViewModel
    @State private var isSearching: Bool = true
    @State private var searchQuery: String = ""
    @Binding var districtSearchIsPresented: Bool
    var body: some View {
        VStack {
            HStack {
                CapsuleTextField(text: $searchQuery, isEditing: $isSearching, icon: "magnifyingglass", onEditingChanged: {query in localeViewModel.searchDistrict(for: query)}, configuration:  {textField in
                    textField.keyboardType = .webSearch
                    textField.autocorrectionType = .no
                    textField.autocapitalizationType = .words
                })
                if isSearching {
                    Button {
                        searchQuery = ""
                        localeViewModel.searchResults = []
                        isSearching = false
                        districtSearchIsPresented = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(DrawingConstants.accentColor)
                    }
                }
            }
            .transition(.opacity)
            .animation(.default)
            .padding()
            
            Spacer()
            ScrollView {
                ForEach(localeViewModel.searchResults) {searchResult in
                    Button {
                        isSearching = false
                        localeViewModel.chosenLocale = searchResult
                        districtSearchIsPresented = false
                    } label: {
                        VStack{
                            DistrictSearchResultCard(for: searchResult)
                            Divider()
                        }
                    }
                    
                }
            }
            
            .padding()
        }
    }
    
    private struct DrawingConstants {
        static let accentColor = Color("Primary")
    }
}

struct DistrictSearchView_Previews: PreviewProvider {
    @StateObject static var localeViewModel = LocaleViewModel()
    static var previews: some View {
        DistrictSearchView(localeViewModel: LocaleViewModel(), districtSearchIsPresented: .constant(true))
    }
}
