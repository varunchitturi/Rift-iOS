//
//  ContentView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct WelcomeView: View {
    
    @StateObject private var localeViewModel = LocaleViewModel()
    @State private var districtSearchIsPresented: Bool = false {
        willSet {
            if districtSearchIsPresented != newValue {
                stateSelectionIsEditing = false
            }
        }
    }
    @State private var stateSelectionIsEditing: Bool = false
    let stateOptions = Locale.USTerritory.allCases.sorted().map {$0.description}
    
    private var navigationDisabled: Bool {
        localeViewModel.chosenLocale == nil
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
                            DistrictSearchView(localeViewModel: localeViewModel, districtSearchIsPresented: $districtSearchIsPresented)
                        }
                }
                NavigationLink(destination: LogInView()) {
                    CapsuleButton("Next", icon: "arrow.right", style: .primary)
                }
                .disabled(navigationDisabled)
                
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



struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .previewDevice("iPod touch (7th generation)")
        WelcomeView()
            .previewDevice("iPhone 11")
    }
}
