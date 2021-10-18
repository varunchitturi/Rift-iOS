//
//  NetworkUtils.swift
//  NetworkUtils
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import SwiftUI
import WebKit

extension URL {
    mutating func insertPathComponent(after component: String, with path: String) {
        let insertingComponent = component
        var components = self.pathComponents
        for (index, component) in components.enumerated() {
            if component == insertingComponent {
                components.insert(path, at: index+1)
                break
            }
        }
        self.pathComponents.forEach {
            if $0 != "/" {
                self.deleteLastPathComponent()
            }
        }
        components.forEach {
            if $0 != "/" {
                self.appendPathComponent($0)
            }
        }
    }
    
    func appendingQueryItems(_ queries: [URLQueryItem]) -> URL? {
        
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        
        var queryItems = components.queryItems ?? []
        for query in queries {
            queryItems.append(query)
        }
        components.queryItems = queryItems
        
        return components.url
    }
}

extension Array where Element: HTTPCookie {
    var cookieHeader: String {
        var header = ""
        self.forEach {header.append("\($0.name)=\($0.value); ")}
        return header
    }
}


extension URLRequest {
    enum HTTPMethod: String {
        case post = "POST", get = "GET", put = "PUT", options = "OPTIONS", head = "HEAD"
    }
    
    enum ContentType: String {
        case json = "application/json", form = "application/x-www-form-urlencoded"
    }
    
    enum Header: String {
        case cookie = "Cookie", contentType = "Content-Type", accept = "Accept"
    }
    
    mutating func setCookieHeader(for cookies: [HTTPCookie]?) {
        if let cookies = cookies {
            self.setValue(cookies.cookieHeader, forHTTPHeaderField: Header.cookie.rawValue)
        }
    }
}

extension HTTPURLResponse {
    enum Status {
        case information
        case success
        case notModified
        case noResponse
        case unauthorized
        case forbidden
        case notFound
        case found
        case serverError
        case unknown
        case badRequest
        case moved
    }
    
    var status: Status {
        switch statusCode {
        case 100..<200:
            return .information
        case 200:
            return .success
        case 204:
            return .noResponse
        case 301:
            return .moved
        case 302:
            return .found
        case 304:
            return .notModified
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500..<600:
            return .serverError
        default:
            return .unknown
        }
    }
}

extension WKHTTPCookieStore {
    
    func clearCookies(completion: @escaping () -> () = {}) {
        
        self.getAllCookies { cookies in
            let waitGroup = DispatchGroup()
            cookies.forEach {
                waitGroup.enter()
                self.delete($0) {
                    waitGroup.leave()
                }
            }
            waitGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    func useOnlyCookies(from cookies: [HTTPCookie], completion: @escaping () -> () = {}) {
        clearCookies {
            let waitGroup = DispatchGroup()
            cookies.forEach { cookie in
                waitGroup.enter()
                self.setCookie(cookie) {
                    waitGroup.leave()
                }
            }
            waitGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
}

enum ResponseState {
    case idle
    case loading
    case failure
}

extension URLSessionConfiguration {
    static let authentication: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.httpCookieAcceptPolicy = .always
        return configuration
    }()
    
    static let secure: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage = .shared
        return configuration
    }()
    
    static let dataLoad: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return configuration
    }()
}

extension HTTPCookieStorage {
    func removeSessionCookies() {
        if let cookies = self.cookies {
            cookies.forEach { cookie in
                if cookie.name != API.Authentication.Cookie.persistent.name {
                   deleteCookie(cookie)
                }
            }
        }
    }
    func clearCookies() {
        self.removeCookies(since: .distantPast)
    }
}


extension URLSession {
    class func reset(from session: URLSession) -> URLSession {
        let configuration = session.configuration
        session.invalidateAndCancel()
        return URLSession(configuration: configuration)
    }
}
