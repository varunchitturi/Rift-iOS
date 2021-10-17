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
    @State private var pointsIsEditing = false
    @ObservedObject var assignmentDetailViewModel: AssignmentDetailViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var courseDetailViewModel: CourseDetailViewModel
    
    // TODO: make capsule textfield more configurable. Accent color should be defaulted to Color("AccentColor")
    
    // TODO: add last modified date
    // TODO: allow editing of categories
    
    init(originalAssignment: Assignment, assignmentToEdit: Binding<Assignment>, gradingCategories: [GradingCategory]) {
        self.assignmentDetailViewModel = AssignmentDetailViewModel(originalAssignment: originalAssignment, assignmentToEdit: assignmentToEdit, gradingCategories: gradingCategories)
    }
    var body: some View {
        ScrollView {
            VStack(spacing: DrawingConstants.spacing) {
                HStack {
                    Text(assignmentDetailViewModel.assignmentName)
                        .font(.title2)
                    Spacer()
                }
                .padding(.top)
                AssignmentDetailStats()
                    .environmentObject(assignmentDetailViewModel)
                CapsuleDropDown("Category", description: "Category", options: assignmentDetailViewModel.gradingCategories.map { $0.name }, selectionIndex: $selectionIndex, isEditing: $categoryIsEditing)
                HStack {
                    CapsuleTextField("Score", text: $assignmentDetailViewModel.scorePointsText, isEditing: $scoreIsEditing, inputType: .decimal)
                    
                    CapsuleTextField("Total points", text: $assignmentDetailViewModel.totalPointsText, isEditing: $pointsIsEditing, inputType: .decimal)
                }
                let remarks = assignmentDetailViewModel.remarks
                ForEach(remarks.keys, id: \.hashValue) { key in
                    let header = key.description
                    let text = remarks[key]!
                    
                    if text != nil {
                        AssignmentDetailSection(header: header, text!)
                    }
                }
                DestructiveButton("Delete Assignment") {
                    assignmentDetailViewModel.assignmentDeleted = true
                    courseDetailViewModel.deleteAssignment(assignmentDetailViewModel.assignmentToEdit)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal)
            .foregroundColor(DrawingConstants.foregroundColor)
        }
        .navigationTitle("Assignment")
        .onAppear {
            assignmentDetailViewModel.getDetail()
        }
        .onDisappear {
            if !assignmentDetailViewModel.assignmentDeleted {
                assignmentDetailViewModel.commitChanges()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    if assignmentDetailViewModel.hasModifications {
                        Button {
                            assignmentDetailViewModel.resetChanges()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                }
            }
        }
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let spacing: CGFloat = 15
    }
}

struct AssignmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentDetailView(originalAssignment: PreviewObjects.assignment, assignmentToEdit: .constant(PreviewObjects.assignment), gradingCategories: [PreviewObjects.gradingCategory])
    }
}
