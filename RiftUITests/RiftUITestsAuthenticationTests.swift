//
//  RiftUITestsAuthenticationTests.swift
//  RiftUITests
//
//  Created by Varun Chitturi on 12/18/22.
//

import XCTest

final class RiftUITestsAuthenticationTests: AuthenticationUITestCase {
    
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
        
}

