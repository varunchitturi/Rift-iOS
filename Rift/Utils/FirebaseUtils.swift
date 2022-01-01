//
//  AnalyticsUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Firebase
import Foundation

extension Analytics {
    static func setUserProperties(_ user: UserAccount) {
        
        setUserID(user.id)
        
        (try? user.allProperties())?.forEach { property, value in
            setUserProperty(String(describing: value), forName: property)
        }
    }
}
