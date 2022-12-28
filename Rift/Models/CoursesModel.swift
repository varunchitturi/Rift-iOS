//
//  CoursesModel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/11/21.
//

import Foundation


/// MVVM model to manage the `CoursesView`
struct CoursesModel {
    
    /// A list of all `GradeTerm`s for the user
    var terms: [GradeTerm]?
}

