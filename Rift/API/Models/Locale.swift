//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI


// TODO: give difference between this and Persistent Core Data. (maybe implement this better). Instead of using PersistentLocale, think of using the @Persisted Wrapper
// TODO: Redo the initializer for this struct so that more of the values can be private or private(set)

/// Identifies the district that the API requests are being made to
struct Locale: Identifiable, Decodable, PropertyIterable {
    
    /// The id for the school district
    var id: String
    
    /// The name of the school district
    var districtName: String
    
    /// The app name given to the district by infinite campus
    /// - Note: This name is used to identify which Infinite Campus app to use in authentication
    var districtAppName: String
    
    /// The base `URL` for all user based API requests
    var districtBaseURL: URL
    
    /// The code given to the district by Infinite Campus
    var districtCode: String
    
    /// The state or territory that this district is located in
    var state: USTerritory
    
    /// The login `URL` that staff use for this district
    var staffLogInURL: URL
    
    /// The login `URL` that staff use for this district
    var studentLogInURL: URL
    
    /// The login `URL` that staff use for this district
    var parentLogInURL: URL
    
    /// The login `URL` for this district based on the current `ApplicationModel.appType`
    var logInURL: URL {
        switch ApplicationModel.appType {
        case .student:
            return studentLogInURL
        case .parent:
            return parentLogInURL
        case .staff:
            return staffLogInURL
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case districtName = "district_name"
        case districtAppName = "district_app_name"
        case districtBaseURL = "district_baseurl"
        case districtCode = "district_code"
        case state = "state_code"
        case staffLogInURL = "staff_login_url"
        case studentLogInURL = "student_login_url"
        case parentLogInURL = "parent_login_url"
    }
    

}
