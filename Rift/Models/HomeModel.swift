//
//  HomeModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI

struct HomeModel {
    
    enum Tab: String, CaseIterable, View {
        case courses = "Courses", assignments = "Assignments", inbox = "Inbox"
        
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
        
        var body: some View {
            Label(self.rawValue, systemImage: self.iconName)
        }
        
        var label: String {
            return rawValue
        }
    }
}
