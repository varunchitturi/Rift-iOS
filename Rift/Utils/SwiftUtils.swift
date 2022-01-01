//
//  SwiftUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 1/1/22.
//

import Foundation

extension String {
    static let nilDisplay = "-"
}

protocol PropertyInspectable {
    func allProperties() throws -> [String: Any]
}

extension PropertyInspectable {
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
