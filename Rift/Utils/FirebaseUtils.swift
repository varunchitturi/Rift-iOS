//
//  AnalyticsUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Firebase
import Foundation

fileprivate extension Analytics {
    static func setUserProperties(_ user: UserAccount) {
        
        setUserID(user.id)
        
        (try? user.allProperties())?.forEach { property, value in
            setUserProperty(String(describing: value), forName: property)
        }
    }
    
    static func setLocale(_ locale: Locale? = nil) {
        guard let locale = (locale ?? PersistentLocale.getLocale()) else {
            return
        }
        Analytics.setDefaultEventParameters(try? locale.allProperties())
    }
    
    private static func clearUserProperties() {
        
        setUserID(nil)
        
        // temp user to access properties
        let user = UserAccount(userID: 0, personID: 0, firstName: "", lastName: "", username: "")
        
        (try? user.allProperties())?.forEach { property, value in
            setUserProperty(nil, forName: property)
        }
    }
    
    private static func clearDefaultProperties() {
        setDefaultEventParameters(nil)
    }
    
    static func clearProperties() {
        clearUserProperties()
        clearDefaultProperties()
    }
    
}

extension FirebaseApp {
    static func setUser(_ user: UserAccount) {
        Analytics.setUserProperties(user)
        Analytics.setLocale()
        Crashlytics.crashlytics().setUserID(user.id)
        
    }
    
    static func clearUser() {
        Analytics.clearProperties()
        Crashlytics.crashlytics().setUserID("")
    }

}
