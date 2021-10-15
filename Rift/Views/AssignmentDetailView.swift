//
//  AssignmentDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/12/21.
//

import SwiftUI

struct AssignmentDetailView: View {
    @State private var selectionIndex: Int? = 0
    @State private var categoryIsEditing = false
    @State private var scoreIsEditing = false
    @State private var score = "10"
    @State private var pointsIsEditing = false
    @State private var points = "25"
    @ObservedObject var assignmentDetailViewModel: AssignmentDetailViewModel
    
    // TODO: make capsule textfield more configurable. Accent color should be defaulted to Color("AccentColor")
    
    // TODO: add last modified date
    
    init(assignment: Assignment, gradingCategories: [GradingCategory]) {
        self.assignmentDetailViewModel = AssignmentDetailViewModel(assignment: assignment, gradingCategories: gradingCategories)
    }
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(assignmentDetailViewModel.assignmentName)
                        .font(.title3)
                    Spacer()
                }
                .padding(.vertical)
                AssignmentDetailStats()
                    .environmentObject(assignmentDetailViewModel)
                    .padding(.bottom)
                CapsuleDropDown("Category", description: "Category", options: assignmentDetailViewModel.gradingCategories.map { $0.name }, selectionIndex: $selectionIndex, isEditing: $categoryIsEditing)
                    .padding(.bottom)
                HStack {
                    CapsuleTextField("Score", text: $score, isEditing: $scoreIsEditing, inputType: .decimal, accentColor: DrawingConstants.accentColor, onEditingChanged: {_ in}, onCommit: {_ in}, configuration: {_ in})
                    
                    CapsuleTextField("Total points", text: $points, isEditing: $pointsIsEditing, inputType: .decimal, accentColor: DrawingConstants.accentColor, onEditingChanged: {_ in}, onCommit: {_ in}, configuration: {_ in})
                }
                .padding(.bottom)
                let remarks = assignmentDetailViewModel.remarks
                ForEach(remarks.keys, id: \.hashValue) { key in
                    let header = key.description
                    let text = remarks[key]!
                    
                    if text != nil {
                        AssignmentDetailSection(header: header, text!)
                    }
                    
                }
            }
            .padding(.horizontal)
            .foregroundColor(DrawingConstants.foregroundColor)
        }
        .navigationTitle("Assignment")
        .onAppear {
            assignmentDetailViewModel.getDetail()
        }
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let accentColor = Color("Primary")
    }
}

struct AssignmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailView(assignment: PreviewObjects.assignment, gradingCategories: [PreviewObjects.gradingCategory])
    }
}
