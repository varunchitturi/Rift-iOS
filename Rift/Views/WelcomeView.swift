//
//  ContentView.swift
//  Rift
//
//  Created by Varun Chitturi on 8/9/21.
//

import SwiftUI

struct WelcomeView: View {
    @State private var stateDropdown: String = ""
    @State private var districtDropdown: String = ""
    @State private var stateExapanded: Bool = false
    @State private var districtExapanded: Bool = false
    var body: some View {
        VStack() {
            VStack{
                HStack {
                    Text("Welcome.")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                        .padding(.top, 50)
                        .padding(.bottom, 60)
                    Spacer()
                }
                
            }
            .background(Color("Theme"))
            .ignoresSafeArea(edges: .top)
           
            VStack{
                    // TODO: change text fields to drop down
                DropDownView(items: ["1","2","3"], title: "State", isExpanded: $stateExapanded, selectedItem: $stateDropdown)
                    .padding()
                    .onChange(of: stateExapanded, perform: { value in
                        districtExapanded = stateExapanded == true ? false : districtExapanded
                    })
               
                DropDownView(items: ["1","2","3"], title: "District", isExpanded: $districtExapanded, selectedItem: $districtDropdown)
                    .padding()
                    .onChange(of: districtExapanded, perform: { value in
                        stateExapanded = districtExapanded == true ? false : stateExapanded
                    })
                
                Spacer()
                
            }
            .padding(.top, 25.0)
            .background(Color.white)
            VStack{
                Button(action: { }, label: {
                    HStack{
                        Spacer()
                        Text("Next")
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("Theme"))
                    .cornerRadius(200)
                })
            }
            .padding()
            .background(Color.white)
        }
        .background(Color("Theme"))
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .previewDevice("iPhone 11")
        WelcomeView()
            .previewDevice("iPhone SE (2nd generation)")
    }
}
