//
//  AddCategoryModel.swift
//  Rift
//
//  Created by Varun Chitturi on 12/26/22.
//

import Foundation

/// MVVM model to handle the `AddCategoryView`
struct AddCategoryModel {
    
    /// The new category that will be added
    var newCategory: GradingCategory
    
    init(useWeight: Bool) {
        newCategory = GradingCategory(id: UUID().hashValue,
                                      name: "Category",
                                      isWeighted: useWeight,
                                      weight: 0,
                                      isCalculated: true,
                                      assignments: [],
                                      usePercent: true)
        
    }
    
    

}
