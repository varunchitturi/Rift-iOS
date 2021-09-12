//
//  DataUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 9/12/21.
//

import Foundation

extension Data {
    var JSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return jsonString
    }
}
