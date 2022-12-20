//
//  UITestUtils.swift
//  RiftUITests
//
//  Created by Varun Chitturi on 12/19/22.
//

import XCTest

extension XCUIElement {
    
    private static let defaultTimeout: Double = 15
    
    /// Waits for a condition on a `XCUIElement` to pass to run a `completion` function
    /// - Parameters:
    ///   - timeout: The time to wait for the condition to pass
    ///   - condition: A boolean function that will be used to check a condition
    ///   - completion: The completion function to run once the condition passes
    func on(timeout: Double = defaultTimeout, condition: @escaping (XCUIElement) -> Bool, completion: @escaping (XCUIElement) -> ()) {
        let startTime = Date.now
        while(!condition(self)) {
            if startTime.distance(to: .now) >= timeout {
                XCTAssert(self.exists)
            }
        }
        completion(self)
    }
    
    /// Taps a `XCUIElement` when it appears
    /// - Parameter timeout: The time to wait for the element to appear
    func tapOnAppear(timeout: Double = defaultTimeout) {
        onAppearAndEnabled(timeout: timeout) { element in
            element.tap()
        }
    }
    
    func typeOnReady(_ text: String, timeout: Double = defaultTimeout) {
        self.on { $0.exists && $0.keyboards.count > 0} completion: { element in
            element.typeText(text)
        }
    }
    
    /// Runs a completion function when a `XCUIElement` appears
    /// - Parameters:
    ///   - timeout: The time to wait for the element to appear
    ///   - completion: The completion function to run once the condition passes
    func onAppear(timeout: Double = defaultTimeout, completion: @escaping (XCUIElement) -> ()) {
        self.on(timeout: timeout, condition: {$0.exists}, completion: completion)
    }
    
    /// Runs a completion function when a `XCUIElement` appears and is enabled
    /// - Parameters:
    ///   - timeout: The time to wait for the element to appear
    ///   - completion: The completion function to run once the element exists and is enabled
    func onAppearAndEnabled(timeout: Double = defaultTimeout, completion: @escaping (XCUIElement) -> ()) {
        self.on(timeout: timeout, condition: {$0.exists && $0.isEnabled}, completion: completion)
    }
    
    /// Waits for an `XCUIElement` and then continues
    /// - Parameter timeout: The time to wait for the element to appear
    func continueOnAppear(timeout: Double = defaultTimeout) {
        self.onAppear(timeout: timeout, completion: {_ in})
    }
}
