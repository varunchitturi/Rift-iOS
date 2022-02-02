//
//  NumberUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 10/7/21.
//

import Foundation


extension Double {
    
    /// Rounds a `Double` without mutation
    /// - Parameter places: The number of places to round to
    /// - Returns: A new rounded `Double`
    func rounded(_ places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
    
    /// Truncates decimals in a `Double` without mutation
    /// - Parameter places: The number of places to truncate
    /// - Returns: A new truncated `Double`
    func truncated(_ places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return floor(self * multiplier) / multiplier
    }
}
