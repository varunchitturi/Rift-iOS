//
//  CombineUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 10/15/21.
//

import Foundation
import SwiftUI

extension Binding {
    
    /// Converts a `Binding` of an optional to an optional `Binding`
    /// - Returns: An optional binding
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard let value = self.wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: {
                return value
            },
            set: { value in
                self.wrappedValue = value
            }
        )
    }
}
