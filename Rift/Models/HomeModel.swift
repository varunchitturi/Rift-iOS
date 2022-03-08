//
//  HomeModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI

/// MVVM model to manage the `HomeView`
struct HomeModel {
    
    /// The Infinite Campus user account if available
    var account: UserAccount?
    
    /// The Infinite Campus student configuration if available
    var student: Student?
    
    /// The home screen tab
    enum Tab: String, CaseIterable, View {
        case courses = "Courses", assignments = "Assignments", inbox = "Inbox"
        
        /// The SF icon name of a home tab
        private var iconName: String {
            switch self {
            case .courses:
                return "graduationcap.fill"
            case .assignments:
                return "doc.text.fill"
            case .inbox:
                return "tray.fill"
            }
        }
        
        /// A `Label` view for a home tab
        var body: some View {
            Label(self.rawValue, systemImage: self.iconName)
        }
        
        /// The string value for a home tab
        var label: String {
            return rawValue
        }
    }
}
