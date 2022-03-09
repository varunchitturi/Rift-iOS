//
//  AddAssignmentView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import SwiftUI

struct AddAssignmentView: View {
    
    @ObservedObject var addAssignmentViewModel: AddAssignmentViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var categoryIsEditing = false
    @State private var scoreIsEditing = false
    @State private var totalIsEditing = false
    @State private var nameIsEditing = false
    
    init(courseName: String, assignments: Binding<[Assignment]>, gradingCategories: [GradingCategory]) {
        addAssignmentViewModel = AddAssignmentViewModel(courseName: courseName, assignments: assignments, gradingCategories: gradingCategories)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DrawingConstants.spacing) {
                    
                    CapsuleTextField("Name", text: $addAssignmentViewModel.assignmentName, isEditing: $nameIsEditing)
                    
                    CapsuleDropDown("Category", description: "Select Category", options: addAssignmentViewModel.categoryNames, selectionIndex: $addAssignmentViewModel.categorySelectionIndex, isEditing: $categoryIsEditing)
                    
                    HStack {
                        CapsuleTextField("Score Points", text: $addAssignmentViewModel.scorePointsText, isEditing: $scoreIsEditing, inputType: .decimal)
                        
                        CapsuleTextField("Total Points", text: $addAssignmentViewModel.totalPointsText, isEditing: $totalIsEditing, inputType: .decimal)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        addAssignmentViewModel.addAssignment()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                    }
                    .disabled(!addAssignmentViewModel.assignmentIsValid)
                }
                
            }
            .navigationTitle("Add Assignment")
            .navigationBarTitleDisplayMode(.inline)
            .logViewAnalytics(self)
        }
    }
    
    private enum DrawingConstants {
        static let spacing: CGFloat = 15
    }
}

#if DEBUG
struct AddAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddAssignmentView(courseName: PreviewObjects.course.name, assignments: .constant(PreviewObjects.gradeDetail.assignments), gradingCategories: PreviewObjects.gradeDetail.categories)
    }
}
#endif
