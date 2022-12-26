//
//  AddCategoryViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 12/26/22.
//

import Foundation
import SwiftUI

/// MVVM view model for `AddCategoryView`
class AddCategoryViewModel: ObservableObject {
    
    /// MVVM model
    @Published var addCategoryModel: AddCategoryModel
    
    /// The list of `GradingCategory`s that the newly created `GradingCategory` will be added to
    @Binding private var categories: [GradingCategory]
    
    /// Gives whether the new `GradingCategory` is a weighted category. `false` if the `GradeDetail` doesn't calculate grades using weights.
    var isWeighted: Bool {
        addCategoryModel.newCategory.isWeighted
    }
    
    init(categories: Binding<[GradingCategory]>) {
        addCategoryModel = AddCategoryModel(useWeight: categories.wrappedValue.allSatisfy({$0.isWeighted}))
        self._categories = categories
    }
    
    /// The new category to be added
    var newCategory: GradingCategory {
        get {
            addCategoryModel.newCategory
        }
        set {
            addCategoryModel.newCategory = newValue
        }
    }
    
    
    /// The text value for the total points field in the `AddCategoryView`
    var weightText: String = "" {
        willSet {
            newCategory.weight = Double(newValue) ?? 0
        }
    }
    
    /// The name of the new category to be added
    var categoryName: String {
        get {
            newCategory.name
        }
        set {
            newCategory.name = newValue
        }
    }
    
    /// Adds the newly created `GradingCategory` to the initial list of `GradingCategory`s
    func addCategory() {
        categories.append(addCategoryModel.newCategory)
    }
  
}
