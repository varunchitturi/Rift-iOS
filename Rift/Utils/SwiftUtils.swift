//
//  SwiftUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation

extension String {
    
    
    /// A string to display nil elements cleanly in a view
    static let nilDisplay = "-"
    
    /// Create a string for a display for an optional element
    init<T>(displaying element: T?) {
        if element != nil {
            self.init(describing: element!)
        }
        else {
            self = String.nilDisplay
        }
        
    }
    
    /// Create a string for a display for optional numeric elements
    init<T>(displaying element: T?, style: NumericStyle) where T: Numeric {
        let string = String(displaying: element)
        
        if element != nil {
            self = string.addingNumericToken(style)
        }
        else {
            self = string
        }
       
    }
    
    
    /// Create a displayable string for doubles
    /// - Parameters:
    ///   - double: Double to display
    ///   - style: The `NumericStyle` to use for the double
    ///   - roundAmount: The amount to round the double to
    init(displaying double: Double?, style: NumericStyle? = nil, roundedTo roundAmount: Int) {
        if let style = style {
            self = String(displaying: double?.rounded(roundAmount), style: style)
        }
        else {
            self = String(displaying: double?.rounded(roundAmount))
        }
    }
    
    
    /// Create a displayable string for doubles
    /// - Parameters:
    ///   - double: Double to display
    ///   - style: The `NumericStyle` to use for the double
    ///   - roundAmount: The amount to truncate the double to
    init(displaying double: Double?, style: NumericStyle? = nil, truncatedTo truncateAmount: Int) {
        if let style = style {
            self = String(displaying: double?.truncated(truncateAmount), style: style)
        }
        else {
            self = String(displaying: double?.truncated(truncateAmount))
        }
    }
    
    /// Create a displayable string for dates
    /// - Parameters:
    ///   - date: Date to display
    ///   - formatter: The `DateFormatter` to use for the date
    init(displaying date: Date?, formatter: DateFormatter) {
        if let date = date {
            self = formatter.string(from: date)
        }
        else {
            self = String.nilDisplay
        }
    }
    
    /// Formatting style for strings of numeric elements
    enum NumericStyle {
        case percentage
        case dollar
        
        var token: String {
            switch self {
            case .percentage:
                return "%"
            case .dollar:
                return "$"
            }
        }
    }
    
    
    /// Adds string tokens for a certain `NumericStyle`
    /// - Parameter style: The `NumericStyle` to use
    /// - Returns: A String that has been formatted according to the given `NumericStyle`
    func addingNumericToken(_ style: NumericStyle) -> String {
        return self.appending(style.token)
    }
}

protocol PropertyIterable {
    /// All properties in a PropertyIterable type
    /// - Returns: A dictionary in which the keys are the property names and values are the property values
    func allProperties() throws -> [String: Any]
}

extension PropertyIterable {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
}
