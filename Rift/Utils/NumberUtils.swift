//
//  NumberUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 10/7/21.
//

import Foundation


extension Double {
    func rounded(_ places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
    
    func truncated(_ places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return floor(self * multiplier) / multiplier
    }
}
