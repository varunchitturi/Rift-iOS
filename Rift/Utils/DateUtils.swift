//
//  DateUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation

extension DateFormatter {
    
    /// A `DateFormatter` in the form `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`
    ///  - Example: `2022-08-22T11:59:59.100Z`
    static var iso180601Full: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    /// A `DateFormatter` in the form `yyyy-MM-dd`
    ///  - Example: `2022-08-29`
    static var yearMonthDayDashedUTC: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    /// A `DateFormatter` in the form `MM-dd-yyyy`
    ///  - Example: `08-29-2004`
    static var simple: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MM-dd-yyyy"
        return formatter
    }
    
    /// A `DateFormatter` in the form `EEEE, M-d-yy`
    ///  - Example: `Jan, 1-1-04`
    static var natural: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "EEEE', 'M-d-yy"
        return formatter
    }
    
    /// A `DateFormatter` in the form `EEEE, M-d-yy, h:mm a`
    ///  - Example: `Jan, 1-1-04, 1:11 PM`
    static var naturalFull: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "EEEE, M-d-yy, h:mm a"
        return formatter
    }
}

extension DecodingError {
    /// Creates a `DecodingError` for parsing a date
    /// - Parameter codingPath: The path to the data that was being parsed
    /// - Returns: A `DecodingError.valueNotFound`
    static func dateDecodingError(for codingPath: [CodingKey]) -> DecodingError {
        return DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: codingPath,
                                                                            debugDescription: "Invalid date found")
        )
    }
}
