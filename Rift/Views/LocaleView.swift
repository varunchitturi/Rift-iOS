//
//  LocaleView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct LocaleView: View {
    
    
    
    @ObservedObject var localeViewModel: LocaleViewModel
    
    @State private var districtSearchIsPresented: Bool = false {
        willSet {
            if districtSearchIsPresented != newValue {
                stateSelectionIsEditing = false
            }
        }
    }
    @State private var stateSelectionIsEditing: Bool = false
    
    @Binding var authenticationState: Bool
    
    let stateOptions = Locale.USTerritory.allCases.sorted().map {$0.description}
    
    private var navigationDisabled: Bool {
        localeViewModel.chosenLocale == nil
    }
   
    init(viewModel: LocaleViewModel, authenticationState: Binding<Bool>) {
        self._authenticationState = authenticationState
        self.localeViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Spacer(minLength: DrawingConstants.formTopSpacing)
                    CapsuleDropDown("State", description: "Choose State", options: stateOptions, selectionIndex: $localeViewModel.stateSelectionIndex, isEditing: $stateSelectionIsEditing)
                        .padding(.bottom)

                    CapsuleFieldModularButton("District", description: "Choose District", text: .constant(localeViewModel.chosenLocale?.districtName), icon: "chevron.down") {
                        localeViewModel.searchResults = []
                        districtSearchIsPresented = true
                    }
                        .disabled(localeViewModel.stateSelectionIndex == nil)
                        .sheet(isPresented: $districtSearchIsPresented) {
                            DistrictSearchView(isPresented: $districtSearchIsPresented).environmentObject(localeViewModel)
                        }
                }
                if localeViewModel.chosenLocale != nil {
                    NavigationLink(destination: LogInView(locale: localeViewModel.chosenLocale!, authenticationState: $authenticationState)) {
                        CapsuleButton("Next", icon: "arrow.right", style: .primary)
                    }
                    .disabled(navigationDisabled)
                }
                else {
                    CapsuleButton("Next", icon: "arrow.right", style: .primary)
                        .disabled(navigationDisabled)
                }
               
                
            }
            .navigationTitle("Welcome")
            .padding()
        }
        .navigationBarColor(backgroundColor: DrawingConstants.navigationColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private struct DrawingConstants {
        static let formTopSpacing: CGFloat = 70
        static let navigationColor = Color("Primary")
    }
}



struct LocaleView_Previews: PreviewProvider {
    @StateObject private static var localeViewModel = LocaleViewModel()
    static var previews: some View {
        LocaleView(viewModel: LocaleViewModel(), authenticationState: .constant(false))
            .previewDevice("iPod touch (7th generation)")
        LocaleView(viewModel: LocaleViewModel(), authenticationState: .constant(false))
            .previewDevice("iPhone 11")
    }
}
