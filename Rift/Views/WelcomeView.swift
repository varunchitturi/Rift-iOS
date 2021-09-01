//
//  ContentView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
// 

import SwiftUI

struct WelcomeView: View {
    @State private var stateSelectionIndex: Int?
    @State private var districtSelectionIndex: Int?
    private var navigationDisabled: Bool {
        stateSelectionIndex == nil || districtSelectionIndex == nil
    }
    
    // TODO: create state selection and district selection computed vars
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Spacer(minLength: DrawingConstants.formTopPadding)
                    CapsuleDropDown("State", description: "Choose State", options: ["CA", "VA"], selectionIndex: $stateSelectionIndex)
                        .padding(.bottom)

                    CapsuleDropDown("District", description: "Choose District", options: ["FUSD", "FUHSD"], selectionIndex: $districtSelectionIndex)
                        .disabled(stateSelectionIndex == nil)
                        .opacity(stateSelectionIndex == nil ? DrawingConstants.disabledOpacity : DrawingConstants.enabledOpacity )
                        
                }
                NavigationLink(destination: LogInView()) {
                    CapsuleButton("Next", icon: "arrow.right", style: .primary)
                        .opacity(navigationDisabled ? DrawingConstants.disabledOpacity : DrawingConstants.enabledOpacity)
                }
                .disabled(navigationDisabled)
                
            }
            .navigationTitle("Welcome")
            .padding()
        }
        .navigationBarColor(backgroundColor: Color("Primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private struct DrawingConstants {
        static let formTopPadding: CGFloat = 70
        static let disabledOpacity = 0.6
        static let enabledOpacity: Double = 1
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
