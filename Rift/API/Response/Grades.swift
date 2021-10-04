//
//  Grades.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API.Endpoint {
    
    static let grades = API.Endpoint(endpointPath: "resources/portal/grades", responseType: GradesResponse.self)
    
    struct GradesResponse: Codable {
        let terms: [Term]
        
        struct Term: Codable {
            let courses: [API.Course]
        }
        
    }
}
