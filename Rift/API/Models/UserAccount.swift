//
//  UserAccount.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation

struct UserAccount: Decodable, Identifiable, PropertyInspectable {
    var id: String {
        userID.description + personID.description
    }
    let userID: Int
    let personID: Int
    let firstName: String
    let lastName: String
    let username: String
    
}
