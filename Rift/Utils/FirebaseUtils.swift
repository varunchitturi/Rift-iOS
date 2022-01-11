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

extension Analytics {
    
    static func logEvent(_ event: AnalyticsEvent) {
        logEvent(event.name, parameters: event.parameters)
    }
   
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
    
    struct LogOutEvent: AnalyticsEvent {
        
        let name: String = "logout"
        
        let parameters: [String : String]? = nil
        
    }
    
    struct ScreenViewEvent: AnalyticsEvent {
        
        let name: String = AnalyticsEventScreenView
        
        let screenName: String
        
        var parameters: [String : String]? {
            [
                AnalyticsParameterScreenName: screenName,
            ]
        }
    }
    
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

protocol AnalyticsEvent {
 
    var name: String  { get }
    
    var parameters: [String: String]? { get }
}


extension FirebaseApp {
    static func setUser(account: UserAccount, student: Student?) {
        Analytics.setUserProperties(Analytics.User(userAccount: account, student: student))
        Analytics.setLocale()
        Crashlytics.crashlytics().setUserID(account.id)
        
    }
    
    static func clearUser() {
        Analytics.clearProperties()
        Crashlytics.crashlytics().setUserID("")
    }

}
