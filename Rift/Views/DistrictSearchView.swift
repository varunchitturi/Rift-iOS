//
//  DistrictSearchView.swift
//  DistrictSearchView
//
//  Created by Varun Chitturi on 9/7/21.
//

import SwiftUI

struct DistrictSearchView: View {
    // TODO: handle bad or no network conditions
    // TODO: create loading state animation
    @EnvironmentObject var welcomeViewModel: WelcomeViewModel
    @State private var isSearching: Bool = true
    @State private var searchQuery: String = ""
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack {
                CapsuleTextField(text: $searchQuery,
                                 isEditing: $isSearching,
                                 icon: "magnifyingglass",
                                 onEditingChanged: { query in
                    welcomeViewModel.searchDistrict(for: query)
                                },
                                configuration: { textField in
                                    textField.keyboardType = .webSearch
                                    textField.autocorrectionType = .no
                                    textField.autocapitalizationType = .words
                                }
                )
                
                if isSearching {
                    Button {
                        searchQuery = ""
                        welcomeViewModel.districtSearchResults = []
                        isSearching = false
                        isPresented = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(DrawingConstants.accentColor)
                    }
                }
            }
            .padding([.horizontal, .top])
            Spacer()
            ScrollView {
                ForEach(welcomeViewModel.districtSearchResults) { searchResult in
                    Button {
                        isSearching = false
                        welcomeViewModel.chosenLocale = searchResult
                        isPresented = false
                    } label: {
                        VStack{
                            DistrictSearchResultCard(for: searchResult)
                            Divider()
                        }
                    }
                }
            }
            .padding([.horizontal, .top])
            .apiHandler(asyncState: welcomeViewModel.districtSearchNetworkState, loadingStyle: .progressCircle) { _ in
                welcomeViewModel.searchDistrict(for: searchQuery)
            }
            if welcomeViewModel.districtSearchNetworkState.isFailure || welcomeViewModel.districtSearchNetworkState == .loading {
                Spacer()
            }
        }
    }
}

#if DEBUG
struct DistrictSearchView_Previews: PreviewProvider {
    @StateObject static var welcomeViewModel = WelcomeViewModel()
    static var previews: some View {
        DistrictSearchView(isPresented: .constant(true))
            .environmentObject(WelcomeViewModel())
    }
}
#endif
