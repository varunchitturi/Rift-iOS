//
//  AssignmentList.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API.Endpoint {
    
    static let assignmentList = API.Endpoint(endpointPath: "api/portal/assignment/listView", responseType: Array<API.Assignment>.self)
    
    
}
