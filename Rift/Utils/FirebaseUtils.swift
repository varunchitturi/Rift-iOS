//
//  FirebaseUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Firebase
import Foundation
import SwiftUI

fileprivate extension Analytics {

    
    /// Sets the user properties for analytics
    /// - Parameter user: The user to set the properties for
    static func setUserProperties(_ user: User) {
        
        let userPropertyMaxLength = 36
        
        setUserID(user.id)
        
        (try? user.allProperties())?.forEach { property, value in
            if let value = value as? String? {
                setUserProperty(value?.prefix(userPropertyMaxLength).description ?? "", forName: property)
            }
            else {
                setUserProperty(String(describing: value), forName: property)
            }
        }
    }
    
    /// Sets the `Locale` for analytics events
    /// - Parameter locale: The locale to set in the events
    static func setLocale(_ locale: Locale? = nil) {
        guard let locale = (locale ?? PersistentLocale.getLocale()) else {
            return
        }
        Analytics.setDefaultEventParameters(try? locale.allProperties())
    }
    
    /// Clears all user properties in analytics
    private static func clearUserProperties() {
        
        setUserID(nil)
        
        let user = UserAccount(userID: 0, personID: 0, firstName: "", lastName: "", username: "")
        
        (try? user.allProperties())?.forEach { property, value in
            setUserProperty(nil, forName: property)
        }
    }
    
    /// Clears any default event parameters in analytics
    private static func clearDefaultProperties() {
        setDefaultEventParameters(nil)
    }
    
    /// Clears any user properties and default event properties including any `Locale` that was set
    static func clearProperties() {
        clearUserProperties()
        clearDefaultProperties()
        
    }
}

extension Analytics {
    
    /// Logs a given `AnalyticsEvent`
    /// - Parameter event: The `AnalyticsEvent` to log
    static func logEvent(_ event: AnalyticsEvent) {
        logEvent(event.name, parameters: event.parameters)
    }
    
    /// An `AnalyticsEvent` for when a user logs in
    struct LogInEvent: AnalyticsEvent {
        
        let method: Method
        
        var process: Process = .unknown
        
        let name: String = "login"
        
        var parameters: [String : String]? {
            [
            "login_method": method.rawValue,
            "login_process": process.rawValue
            ]
        }
        
        enum Method: String {
            case manual
            case automatic
        }
        
        enum Process: String {
            case sso
            case credential
            case unknown
        }
        
    }
    
    /// An `AnalyticsEvent` for when a user logs out
    struct LogOutEvent: AnalyticsEvent {
        
        let name: String = "logout"
        
        let parameters: [String : String]? = nil
        
    }
    
    /// An `AnalyticsEvent` for when a user views a screen
    struct ScreenViewEvent: AnalyticsEvent {
        
        let name: String = AnalyticsEventScreenView
        
        let screenName: String
        
        var parameters: [String : String]? {
            [
                AnalyticsParameterScreenName: screenName,
            ]
        }
    }
    
    
    /// A `User` to log analytics for
    struct User: PropertyIterable {
        let id: String
        let name: String?
        let studentID: String?
        let username: String
        let grades: String?
        let schoolNames: String?
        let districtName: String?
        let state: String?
        
        
        init(userAccount: UserAccount, student: Student?, locale: Locale? = nil) {
            id = userAccount.id
            name = "\(student?.firstName ?? "") \(student?.middleName ?? "") \(student?.lastName ?? "") \(student?.suffix ?? "")"
            studentID = student?.studentNumber
            username = userAccount.username
            grades = student?.enrollments.map({ $0.grade }).joined(separator: ", ")
            schoolNames = student?.enrollments.map({ $0.schoolName }).joined(separator: ", ")
            let locale = locale ?? PersistentLocale.getLocale()
            districtName = locale?.districtName
            state = locale?.state.description
        }
    }
}

/// An event that analytics could be logged for
protocol AnalyticsEvent {
 
    var name: String  { get }
    
    var parameters: [String: String]? { get }
}


extension FirebaseApp
{
    /// Sets a user for all firebase logging
    /// - Parameters:
    ///   - account: The `UserAccount` for the user
    ///   - student: The student information for a user
    static func setUser(account: UserAccount, student: Student?) {
        Analytics.setUserProperties(Analytics.User(userAccount: account, student: student))
        Analytics.setLocale()
        Crashlytics.crashlytics().setUserID(account.id)
        
    }
    
    /// Clears a user from all firebase logging
    static func clearUser() {
        Analytics.clearProperties()
        Crashlytics.crashlytics().setUserID("")
    }

}
