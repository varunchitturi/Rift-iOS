//
//  API.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation

struct API {
    
    static let defaultURLSession = URLSession(configuration: .dataLoad)
    
    enum APIError: Error {
        case invalidData
    }
}
