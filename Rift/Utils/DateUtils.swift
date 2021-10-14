//
//  DateUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 9/19/21.
//

import Foundation

extension DateFormatter {
    static var iso180601Full: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    static var yearMonthDayDashedUTC: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    static var simpleDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MM-dd-yyyy"
        return formatter
    }
}

extension DecodingError {
    static func dateDecodingError(for codingPath: [CodingKey]) -> DecodingError {
        return DecodingError.valueNotFound(Date.self, DecodingError.Context(codingPath: codingPath,
                                                                            debugDescription: "Invalid date found")
        )
    }
}
