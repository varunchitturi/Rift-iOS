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
}
