//
//  Application.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

import Foundation

struct Application {
    
    static var appType: AppType = .student
    
    var authenticationState: Bool
    
    enum AppType: String {
        case student, parent, staff
        
        var description: String {
            self.rawValue
        }
    }
}
