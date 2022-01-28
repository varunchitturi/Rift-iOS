//
//  PreviewObjects.swift
//  Rift
//
//  Created by Varun Chitturi on 9/12/21.
//


#if DEBUG

import Foundation

// TODO: make sure that this does not compile in debug
struct PreviewObjects {
    static let locale = Locale(id: 1, districtName: "Fremont Unified School District", districtAppName: "fremont", districtBaseURL: URL(string: "https://fremontunifiedca.infinitecampus.org/campus/")!, districtCode: "qjnmct", state: .CA, staffLogInURL: URL(string: "https://fremontunifiedca.infinitecampus.org/campus/fremont.jsp")!, studentLogInURL: URL(string: "https://fremontunifiedca.infinitecampus.org/campus/portal/students/fremont.jsp")!, parentLogInURL: URL(string: "https://fremontunifiedca.infinitecampus.org/campus/portal/parents/fremont.jsp")!)
    
    static var authCookies: HTTPCookieStorage {
        let cookies = HTTPCookieStorage()
        cookies.setCookie(HTTPCookie(properties:
                                        [
                                            HTTPCookiePropertyKey(rawValue: "Name"): "JSESSIONID",
                                            HTTPCookiePropertyKey(rawValue: "Value"): "B1506D15A95CBC1BDB56564846682CF5"
                                        ])!
        )
        cookies.setCookie(HTTPCookie(properties:
                                        [
                                            HTTPCookiePropertyKey(rawValue: "Name"): "sis-cookie",
                                            HTTPCookiePropertyKey(rawValue: "Value"): "!ekoM0ifSqFXw8BnSf/2u9QgDYPqI3LvRqEEUeI7kWkmmZiDkwdoVxyvRmzcPklD/Y3XI89znrBXrArM="
                                        ])!
        )
        cookies.setCookie(HTTPCookie(properties:
                                        [
                                            HTTPCookiePropertyKey(rawValue: "Name"): "XSRF-TOKEN",
                                            HTTPCookiePropertyKey(rawValue: "Value"): "c60197b2-9a1c-4fce-91ff-13ef95bdc374"
                                        ])!
        )
        return cookies
    }
    
    static let grade = Grade(letterGrade: "A", percentage: 90, currentPoints: 90, totalPoints: 100, termName: "Q1", termType: "Quarter", termID: 1, hasInitialAssignments: true, hasCompositeTasks: false, cumulativeTermName: nil)
    static let assignment = Assignment(id: 1, isActive: true, name: "Find a frog", dueDate: Date() + 2, assignedDate: Date(), courseName: "How to cook frogs", totalPoints: 100, scorePoints: 90, comments: nil, categoryName: "Unit Test")
    
    static let course = Course(id: 2, sectionID: 3, courseName: "The Magic Arts", teacherName: "Mr. ooba", grades: [grade], isDropped: false)
    
    static let gradeDetail = GradeDetail(grade: grade, categories: [gradingCategory], linkedGrades: nil)
    
    static let gradingCategory = GradingCategory(id: 4, name: "Judgement", isWeighted: true, weight: 100, isExcluded: false, assignments: [assignment], usePercent: false)
        
    static let message = Message(id: 5, courseID: 6, postedTime: Date(), date: Date(), unread: true, endpoint: "portal/messageView.xsl?x=messenger.MessengerEngine-getMessageRecipientView&messageID=5063&messageRecipientID=1777546&processMessageID=965771", type: .default, name: "Library Closure")
    
}
#endif
