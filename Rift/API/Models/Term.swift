//
//  Term.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

struct Term: Codable {
    // TODO: change this to actual grades
    
    let id: Int
    let termName: String
    let termScheduleName: String
    let startDate: Date
    let endDate: Date
    
}
