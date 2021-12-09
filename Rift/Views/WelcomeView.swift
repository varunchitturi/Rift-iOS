//
//  WelcomeView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct WelcomeView: View {
    
    
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    @StateObject var welcomeViewModel = WelcomeViewModel()
    
    @State private var districtSearchIsPresented: Bool = false {
        willSet {
            if districtSearchIsPresented != newValue {
                stateSelectionIsEditing = false
            }
        }
    }
    @State private var stateSelectionIsEditing: Bool = false
    
    let stateOptions = Locale.USTerritory.allCases.sorted().map {$0.description}
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Spacer(minLength: DrawingConstants.formTopSpacing)
                    CapsuleDropDown("State", description: "Choose State", options: stateOptions, selectionIndex: $welcomeViewModel.stateSelectionIndex, isEditing: $stateSelectionIsEditing)
                        .padding(.bottom)

                    CapsuleFieldModularButton("District", description: "Choose District", text: .constant(welcomeViewModel.chosenLocale?.districtName), icon: "chevron.down") {
                        welcomeViewModel.districtSearchResults = []
                        districtSearchIsPresented = true
                    }
                        .disabled(welcomeViewModel.stateSelectionIndex == nil)
                        .sheet(isPresented: $districtSearchIsPresented) {
                            DistrictSearchView(isPresented: $districtSearchIsPresented).environmentObject(welcomeViewModel)
                        }
                }
                if welcomeViewModel.chosenLocale != nil {
                    NavigationLink(
                        destination: LogInView(locale: welcomeViewModel.chosenLocale!)
                                    .environmentObject(applicationViewModel)
                    ) {
                        CapsuleButton("Next", icon: "arrow.right", style: .primary)
                    }
                    .disabled(welcomeViewModel.navigationIsDisabled)
                }
                else {
                    CapsuleButton("Next", icon: "arrow.right", style: .primary)
                        .disabled(welcomeViewModel.navigationIsDisabled)
                }
               
                
            }
            .padding()
            .navigationTitle("Welcome")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // explain why we do this. To refresh provisional cookies
            welcomeViewModel.reset()
        }
    }
    
    private struct DrawingConstants {
        static let formTopSpacing: CGFloat = 70
    }
}


#if DEBUG
struct WelcomeView_Previews: PreviewProvider {
    @StateObject private static var welcomeViewModel = WelcomeViewModel()
    static var previews: some View {
        WelcomeView()
            .previewDevice("iPod touch (7th generation)")
        WelcomeView()
            .previewDevice("iPhone 11")
    }
}
#endif
