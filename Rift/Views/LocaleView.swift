//
//  LocaleView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct LocaleView: View {
    
    
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    @StateObject var localeViewModel = LocaleViewModel()
    
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
                            DistrictSearchView(isPresented: $districtSearchIsPresented).environmentObject(localeViewModel)
                        }
                }
                if localeViewModel.chosenLocale != nil {
                    NavigationLink(
                        destination: LogInView(locale: localeViewModel.chosenLocale!)
                                    .environmentObject(applicationViewModel)
                    ) {
                        CapsuleButton("Next", icon: "arrow.right", style: .primary)
                    }
                    .disabled(navigationDisabled)
                }
                else {
                    CapsuleButton("Next", icon: "arrow.right", style: .primary)
                        .disabled(navigationDisabled)
                }
               
                
            }
            .padding()
            .navigationTitle("Welcome")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // explain why we do this
            localeViewModel.resetQueries()
        }
    }
    
    private struct DrawingConstants {
        static let formTopSpacing: CGFloat = 70
    }
}



struct LocaleView_Previews: PreviewProvider {
    @StateObject private static var localeViewModel = LocaleViewModel()
    static var previews: some View {
        LocaleView()
            .previewDevice("iPod touch (7th generation)")
        LocaleView()
            .previewDevice("iPhone 11")
    }
}
