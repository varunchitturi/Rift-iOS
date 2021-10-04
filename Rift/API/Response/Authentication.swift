//
//  Authentication.swift
//  Rift
//
//  Created by Varun Chitturi on 10/4/21.
//

import Foundation

extension API.Endpoint {
    static let provisionCookies = API.Endpoint(endpointPath: "mobile/hybridAppUtil.jsp", responseType: nil)
    static let persistenceUpdate = API.Endpoint(endpointPath: "resources/portal/hybrid-device/update", responseType: nil)
    static let logOut = API.Endpoint(endpointPath: "logoff.jsp", responseType: nil)
    static let authorization = API.Endpoint(endpointPath: "verify.jsp", responseType: nil)
    static let authenticationSuccess = API.Endpoint(endpointPath: "nav-wrapper", responseType: nil)
}
