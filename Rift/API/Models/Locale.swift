//
//  Locale.swift
//  Rift
//
//  Created by Varun Chitturi on 9/1/21.
//

import Foundation
import SwiftUI


// TODO: give difference between this and Persistent Core Data. (maybe implement this better). Instead of using PersistentLocale, think of using the @Persisted Wrapper

struct Locale: Identifiable, Decodable, PropertyInspectable {
    
    var id: Int
    var districtName: String
    var districtAppName: String
    var districtBaseURL: URL
    var districtCode: String
    var state: USTerritory
    var staffLogInURL: URL
    var studentLogInURL: URL
    var parentLogInURL: URL
    
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
