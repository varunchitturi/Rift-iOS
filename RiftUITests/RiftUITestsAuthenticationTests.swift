//
//  RiftUITestsAuthenticationTests.swift
//  RiftUITests
//
//  Created by Varun Chitturi on 12/18/22.
//

import XCTest

final class RiftUITestsAuthenticationTests: XCTestCase {
    
    enum LogInMethod: String, CaseIterable {
        case google
        case microsoft
        case credential
        
        var environmentKey: String {
            return self.rawValue.uppercased()
        }
    }
    
    struct Account {
        let username: String
        let password: String
        let state: String
        let districtName: String
        let loginMethod: LogInMethod
    }
    
    var accounts = [Account]()
    

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
        
        let app = XCUIApplication()
        app.launch()
        
        if !app.textFields["Choose State"].exists {
            app.buttons["Log Out"].tapIfAppear(timeout: 7)
            logOut(app)
        }
    }

    override func tearDownWithError() throws {
    }

    func testGoogleSSOLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let googleAccounts = accounts.filter({$0.loginMethod == .google})
        
        for account in googleAccounts {
            simulateAuthenticationFlow(app, account: account)
        }
    }
    
    
    func testCredentialLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let credentialAccounts = accounts.filter({$0.loginMethod == .credential})
        
        for account in credentialAccounts {
            simulateAuthenticationFlow(app, account: account)
        }
    }

    
    func testAllLogins() throws {
        let app = XCUIApplication()
        app.launch()
        
        for account in accounts {
            simulateAuthenticationFlow(app, account: account)
        }
    }
    
    func testAllLoginsHeavy() throws {
        let app = XCUIApplication()
        app.launch()
        
        let accountSequence = accounts + accounts.reversed() + accounts
        
        for account in accountSequence {
            simulateAuthenticationFlow(app, account: account)
        }
    }
    
    /// Gets account information based from provided environment variables
    /// - Parameters:
    ///   - accountType: The type of account to get
    ///   - index: The index of the environment variable if provided
    /// - Returns: An `Account` if possible to create from the environment values
    private func getAccountFromEnvironment(accountType: LogInMethod, index: Int? = nil) -> Account? {
        let environmentKeySuffix = index != nil ? "_\(index!)" : ""
        let username = ProcessInfo.processInfo.environment["\(accountType.environmentKey)_USERNAME\(environmentKeySuffix)"]
        let password = ProcessInfo.processInfo.environment["\(accountType.environmentKey)_PASSWORD\(environmentKeySuffix)"]
        let state = ProcessInfo.processInfo.environment["\(accountType.environmentKey)_STATE\(environmentKeySuffix)"] ?? ProcessInfo.processInfo.environment["DEFAULT_STATE"]
        let districtName = ProcessInfo.processInfo.environment["\(accountType.environmentKey)_DISTRICT\(environmentKeySuffix)"] ?? ProcessInfo.processInfo.environment["DEFAULT_DISTRICT"]
        if let username, let password, let state, let districtName {
            return Account(username: username, password: password, state: state, districtName: districtName, loginMethod: accountType)
        }
        return nil
    }
    
    /// Simulates the entire authentication flow starting from the `WelcomeView`. It will log in, and log out bringing you back to the `WelcomeView`.
    /// - Parameters:
    ///   - app: A launched app
    ///   - account: The account to simulate authentication with
    private func simulateAuthenticationFlow(_ app: XCUIApplication, account: Account) {
        chooseLocale(app, account: account)
        switch account.loginMethod {
        case .google:
            googleSSOLogin(app, account: account)
        case .credential:
            credentialLogin(app, account: account)
        default:
            XCTAssert(false, "Authentication flow for \(account.loginMethod) not implemented")
        }
        logOutWithPersistenceCheck(app)
    }
    
    /// Chooses a state and district specified in an `Account` object
    /// - Parameters:
    ///   - app:A launched app
    ///   - account: The account to get the state and district from
    /// - Note: You must be in the `WelcomeView`
    private func chooseLocale(_ app: XCUIApplication, account: Account) {
        app.textFields["Choose State"].tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: account.state)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["District, Choose District"].tap()
        app.typeOnReady(String(account.districtName.prefix(3)))
        app.buttons[account.districtName].tapOnAppear()
        app.buttons["Next"].tap()
    }
    
    /// Runs a google SSO login workflow
    /// - Parameters:
    ///   - app: A launched app
    ///   - account: An account with `Google` credentials
    /// - Note: You must be in the `LogInView`
    private func googleSSOLogin(_ app: XCUIApplication, account: Account) {
        app.buttons["Single Sign-On"].tapOnAppear()
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
        app.alerts["Stay Logged In"].onAppear { element in
            element.buttons["Yes"].tap()
        }
    }
    
    /// Logs in a user using credential login
    /// - Parameters:
    ///   - app: A launched app
    ///   - account: The account to log in with
    /// - Note: You must be in the `LogInView`
    private func credentialLogin(_ app: XCUIApplication, account: Account) {
        let usernameElementsQuery = app.scrollViews.otherElements.containing(.staticText, identifier:"Username")
        usernameElementsQuery.children(matching: .textField).element.tapOnAppear()
        app.typeOnReady(account.username)
        usernameElementsQuery.children(matching: .secureTextField).element.tap()
        app.typeOnReady(account.password)
        app.buttons["Log In"].tap()
        app.alerts["Stay Logged In"].onAppear { element in
            element.buttons["Yes"].tap()
        }
    }
    
    /// Logs out a user and checks if the user has obtained a `persistent-cookie`
    /// - Parameter app: A launched app
    /// - Note: The user must be at the home of the app
    private func logOutWithPersistenceCheck(_ app: XCUIApplication) {
        app.navigationBars["Courses"]/*@START_MENU_TOKEN@*/.buttons["gearshape.fill"]/*[[".otherElements[\"gearshape.fill\"].buttons[\"gearshape.fill\"]",".buttons[\"gearshape.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.perform(timeout: 5, while: {_ in !app.collectionViews/*@START_MENU_TOKEN@*/.switches["Stay Logged In"]/*[[".cells.switches[\"Stay Logged In\"]",".switches[\"Stay Logged In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists}) { element in
            element.tap()
        }
        XCTAssert(app.collectionViews/*@START_MENU_TOKEN@*/.switches["Stay Logged In"]/*[[".cells.switches[\"Stay Logged In\"]",".switches[\"Stay Logged In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String == "1")
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Log Out"]/*[[".cells.buttons[\"Log Out\"]",".buttons[\"Log Out\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tapOnAppear()
        app.textFields["Choose State"].continueOnAppear()
    }
    
    /// Logs out a user
    /// - Parameter app: A launched app
    /// - Note: The user must be at the home of the app
    private func logOut(_ app: XCUIApplication) {
        app.navigationBars["Courses"]/*@START_MENU_TOKEN@*/.buttons["gearshape.fill"]/*[[".otherElements[\"gearshape.fill\"].buttons[\"gearshape.fill\"]",".buttons[\"gearshape.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tapOnAppear()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Log Out"]/*[[".cells.buttons[\"Log Out\"]",".buttons[\"Log Out\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tapOnAppear()
        app.textFields["Choose State"].continueOnAppear()
    }
}

