//
//  PreviewObjects.swift
//  Rift
//
//  Created by Varun Chitturi on 9/12/21.
//


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
    
    static let grade = Grade(letterGrade: "A", percentage: 90, currentPoints: 90, totalPoints: 100, termName: "Q1", termType: "Quarter", groupWeighted: false)
    static let assignment = Assignment(id: 1, isActive: true, assignmentName: "Find a frog", dueDate: Date() + 2, assignedDate: Date(), courseName: "How to cook frogs", totalPoints: 100, scorePoints: 90, comments: nil, feedback: nil, categoryName: "Unit Test")
    
    static let course = Course(id: 112, sectionID: 1234, courseName: "The Magic Arts", teacherName: "Mr. ooba", grades: [grade], isDropped: false)
    
    static let gradeDetail = GradeDetail(grade: grade, categories: [gradingCategory])
    
    static let gradingCategory = GradingCategory(id: 1, name: "Judgement", isWeighted: true, weight: 100, isExcluded: false, assignments: [assignment])
        
    
    
}
