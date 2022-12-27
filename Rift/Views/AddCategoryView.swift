//
//  AddCategoryView.swift
//  Rift
//
//  Created by Varun Chitturi on 12/26/22.
//

import SwiftUI


struct AddCategoryView: View {
    
    @ObservedObject var addCategoryViewModel: AddCategoryViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var weightIsEditing = false
    @State private var nameIsEditing = false
    
    init(categories: Binding<[GradingCategory]>) {
        addCategoryViewModel = AddCategoryViewModel(categories: categories)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DrawingConstants.spacing) {
                    
                    CapsuleTextField("Name", text: $addCategoryViewModel.categoryName, isEditing: $nameIsEditing)
                    
                    if addCategoryViewModel.isWeighted {
                        CapsuleTextField("Weight", text: $addCategoryViewModel.weightText, isEditing: $weightIsEditing, inputType: .decimal)
                    }
                    Toggle(isOn: $addCategoryViewModel.usePercent) {
                        Text("Use Percent")
                    }
                    Text("If on, an assignment scored 50/100 is worth the same as an assignment scored 1/2.")
                        .font(.caption2)
                }
                .foregroundColor(Rift.DrawingConstants.foregroundColor)
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        addCategoryViewModel.addCategory()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .logViewAnalytics(self)
        }
    }
    
    private enum DrawingConstants {
        static let spacing: CGFloat = 15
    }
}

#if DEBUG
struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(categories: .constant(PreviewObjects.gradeDetail.categories))
    }
}
#endif
