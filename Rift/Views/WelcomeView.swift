//
//  ContentView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct WelcomeView: View {
    @State private var stateSelectionIndex: Int?
    @State private var districtSelection: String?
    
    let stateOptions = LocaleUtils.USTerritory.allCases.sorted() as! [String]
    private var navigationDisabled: Bool {
        stateSelectionIndex == nil || districtSelection == nil
        
    }
    
    private var stateSelection: String? {
        return stateSelectionIndex != nil ? stateOptions[stateSelectionIndex!] : nil
    }
    // TODO: create state selection and district selection computed vars
    
    
   
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Spacer(minLength: DrawingConstants.formTopSpacing)
                    CapsuleDropDown("State", description: "Choose State", options: stateOptions, selectionIndex: $stateSelectionIndex)
                        .padding(.bottom)

                    CapsuleFieldModularButton("District", description: "Choose District", text: $districtSelection, icon: "chevron.down") {
                        
                    }
                        .disabled(stateSelectionIndex == nil)
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
