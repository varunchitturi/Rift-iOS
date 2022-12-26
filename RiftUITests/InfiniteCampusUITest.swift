//
//  InfiniteCampusUITest.swift
//  RiftUITests
//
//  Created by Varun Chitturi on 12/25/22.
//

import XCTest

final class InfiniteCampusUITest: AuthenticationUITestCase {
    
    private static let ICBundleIdentifier = "com.infinitecampus.student.campusportalhybrid"
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        for method in LogInMethod.allCases {
            if let account = getAccountFromEnvironment(accountType: method) {
                accounts.append(account)
            }
            
            var accountIndex = 1
            while let account = getAccountFromEnvironment(accountType: method, index: accountIndex) {
                accounts.append(account)
                accountIndex += 1
            }
        }
        
        XCTAssert(accounts.count > 0, "No accounts provided to test.")
    }
    

    func testAllLoginsHeavy() throws {
        let app = XCUIApplication(bundleIdentifier: InfiniteCampusUITest.ICBundleIdentifier)
        app.launch()
        
        
        let accountSequence = accounts + accounts.reversed() + accounts
        
        for account in accountSequence {
            simulateAuthenticationFlow(app, account: account)
        }
    }
    
    override func simulateAuthenticationFlow(_ app: XCUIApplication, account: Account) {
        chooseLocale(app, account: account)
        switch account.loginMethod {
        case .google:
            googleSSOLogin(app, account: account)
        case .credential:
            credentialLogin(app, account: account)
        default:
            XCTAssert(false, "Authentication flow for \(account.loginMethod) not implemented")
        }
        logOut(app)
    }

    
    override func googleSSOLogin(_ app: XCUIApplication, account: AuthenticationUITestCase.Account) {
        app.links["Single Sign-On (SSO)"].tapOnAppear()
               
        let webViewsQuery = app.webViews.webViews.webViews
        let ssoEmailField = webViewsQuery/*@START_MENU_TOKEN@*/.textFields["Email or phone"]/*[[".otherElements[\"Sign in - Google Accounts\"].textFields[\"Email or phone\"]",".textFields[\"Email or phone\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        ssoEmailField.onAppear { element in
            element.perform(while: {_ in app.keyboards.count == 0}) { element in
                element.tap()
                
            }
            
        }
        app.typeText(account.username)
        webViewsQuery/*@START_MENU_TOKEN@*/.buttons["Next"]/*[[".otherElements[\"Sign in - Google Accounts\"].buttons[\"Next\"]",".buttons[\"Next\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let ssoPasswordField = webViewsQuery.otherElements["Google Accounts"].children(matching: .secureTextField).element
        ssoPasswordField.onAppear { element in
            element.perform(while: {element in app.keyboards.count == 0 && !element.isSelected}) { element in
                element.tap()
                
            }
            
        }
        app.typeText(account.password)
        webViewsQuery/*@START_MENU_TOKEN@*/.otherElements["Google Accounts"].buttons["Sign in"]/*[[".otherElements[\"Google Accounts\"].buttons[\"Sign in\"]",".buttons[\"Sign in\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
       
        app.otherElements["Yes"].tapOnAppear()
        
    }
    
    override func credentialLogin(_ app: XCUIApplication, account: AuthenticationUITestCase.Account) {
        app.textFields.element.tapOnAppear()
        app.typeText(account.username)
        app.secureTextFields.element.tap()
        app.typeText(account.password)
        app.buttons["Log In"].tap()
    }
    
    override func logOut(_ app: XCUIApplication) {
        app.buttons["User Menu"].tapOnAppear()
        app.links["Log Off"].tapOnAppear()
    }
    
    override func chooseLocale(_ app: XCUIApplication, account: Account) {
        app.links["Change District"].tapIfAppear(timeout: 5)
        app.textFields.element.tapOnAppear()
        app.typeText(String(account.districtName.prefix(3)))
        app.otherElements["State"].tap()
        app.buttons[account.state].tap()
        app.otherElements["Search District"].otherElements.element.tap()
        
        let districtPredicate = NSPredicate(format: "label BEGINSWITH '\(account.districtName)'")
        let districtSelection = app.scrollViews.otherElements.element(matching: districtPredicate)
        
        districtSelection.children(matching: .other).firstMatch.tap()
    }

}
