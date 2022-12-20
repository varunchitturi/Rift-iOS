//
//  UserAccount.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation

/// Information on the account of the Infinite Campus user
struct UserAccount: Decodable, Identifiable, PropertyIterable {
    
    /// An id used to identify a user account
    /// - This `id` should be used to identify Infinite Campus users throughout your app
    /// - This is a computed property that is a combination of the `userID` and the `personID`
    /// - Note: This value is not generated from Infinite Campus
    var id: String {
        userID.description + personID.description
    }
    
    /// An Infinite Campus provided `userID`
    /// - Important: Do not use this value to identify Infinite Campus users in your app
    let userID: Int
    
    /// An Infinite Campus provided `personID`
    /// - Important: Do not use this value to identify Infinite Campus users in your app
    let personID: Int
    
    /// The first name of the user
    let firstName: String?
    
    /// The last name of the user
    let lastName: String?
    
    /// The username of the user
    let username: String
    
}
