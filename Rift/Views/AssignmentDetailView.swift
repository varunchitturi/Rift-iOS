//
//  AssignmentDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/12/21.
//

import SwiftUI

struct AssignmentDetailView: View {
    let assignment: Assignment
    let categories: [GradingCategory]
    @State private var selectionIndex: Int? = 0
    @State private var categoryIsEditing = false
    @State private var scoreIsEditing = false
    @State private var score = "10"
    @State private var pointsIsEditing = false
    @State private var points = "25"
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text(assignment.assignmentName)
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    VStack {
                        Text("Due")
                            .font(.caption2.bold())
                            .foregroundColor(Color("Primary"))
                            .padding(.bottom, 5)
                        Text("10/10/21")
                        
                            .font(.caption2)
                    }
                    Spacer()
                    VStack {
                        Text("Assigned")
                            .font(.caption2.bold())
                        
                        .padding(.bottom, 5)
                            .foregroundColor(Color("Primary"))
                        Text("10/10/21")
                        
                            .font(.caption2)
                    }
                    Spacer()
                    VStack {
                        Text("Real")
                            .font(.caption2.bold())
                        
                            .padding(.bottom, 5)
                            .foregroundColor(Color("Primary"))
                        Text("83.32%")
                        
                            .font(.caption2)
                    }
                    Spacer()
                    VStack {
                        Text("Calculated")
                            .font(.caption2.bold())
                        
                            .padding(.bottom, 5)
                            .foregroundColor(Color("Primary"))
                        Text("83.32%")
                            .font(.caption2)
                    }
                }
                .padding(.bottom)
                CapsuleDropDown("Category", description: "Category", options: categories.map { $0.name }, selectionIndex: $selectionIndex, isEditing: $categoryIsEditing)
                    .padding(.bottom)
                HStack {
                    
                    CapsuleTextField("Score", text: $score, isEditing: $scoreIsEditing, accentColor: Color("Primary"), isSecureStyle: false, onEditingChanged: {_ in}, onCommit: {_ in}, configuration: {_ in})
                    
                    CapsuleTextField("Total points", text: $points, isEditing: $pointsIsEditing, accentColor: Color("Primary"), isSecureStyle: false, onEditingChanged: {_ in}, onCommit: {_ in}, configuration: {_ in})
                }
                VStack(alignment: .leading) {
                    Text("Summary")
                        .font(.caption.bold())
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("Secondary"))
                        Text("You have been marked absent")
                            .font(.callout)
                            .foregroundColor(Color("Tertiary"))
                            .padding()
                        
                    }
                        .foregroundColor(Color("Secondary"))
                    
                }
                VStack(alignment: .leading) {
                    Text("Feedback")
                        .font(.caption.bold())
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("Secondary"))
                        Text("You are really bad at math")
                            .font(.callout)
                            .foregroundColor(Color("Tertiary"))
                            .padding()
                        
                    }
                        .foregroundColor(Color("Secondary"))
                    
                }
                VStack(alignment: .leading) {
                    Text("Comments")
                        .font(.caption.bold())
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("Secondary"))
                        Text("I suggest you drop this class as quickly as possible for your own benefit")
                            .font(.callout)
                            .foregroundColor(Color("Tertiary"))
                            .padding()
                        
                    }
                        .foregroundColor(Color("Secondary"))
                    
                }
                
            }
            .padding()
            .navigationTitle("Assignment")
        }
    }
}

struct AssignmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailView(assignment: PreviewObjects.assignment, categories: [PreviewObjects.gradingCategory])
    }
}
