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
    
    /// Insert a path component after a given path component
    /// - Parameters:
    ///   - component: The component to insert after
    ///   - path: The path to insert
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
    
    /// The host URL of a `URL`
    /// - Note: is`nil` if the data cannot be represented as `JSON`
    var hostURL: URL? {
        guard let host = self.host else {
            return nil
        }
        var components = URLComponents()
        components.host = host
        components.scheme = "https"
        return components.url
    }
    
    /// Creates a new `URL` with queries
    /// - Parameter queries: Queries to add to the `URL`
    /// - Returns: A new `URL` with the query items appended
    func appendingQueryItems(_ queries: [URLQueryItem]) -> URL? {
        
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        
        var queryItems = components.queryItems ?? []
        for query in queries {
            queryItems.append(query)
        }
        components.queryItems = queryItems
        
        return components.url
    }
    
    /// Creates a new `URL` without any queries
    /// - Returns: A new `URL` without any queries
    func removingQueries() -> URL? {
        var components = URLComponents(string: self.absoluteString)
        components?.query = nil
        return components?.url
    }
    
}

extension Array where Element: HTTPCookie {
    
    /// A string to use in value of the `Cookie` HTTP header field such that the network request will
    /// contain the cookies in the array.
    var cookieHeader: String {
        var header = ""
        self.forEach {header.append("\($0.name)=\($0.value); ")}
        return header
    }
}


extension URLRequest {
    
    /// A HTTP method to use in a `URLRequest`
    enum HTTPMethod: String {
        case post = "POST", get = "GET", put = "PUT", options = "OPTIONS", head = "HEAD"
    }
    
    /// The content type to use in a `URLRequest`
    enum ContentType: String {
        case json = "application/json", form = "application/x-www-form-urlencoded"
    }
    
    /// A key in a HTTP Header Field
    enum Header: String {
        case cookie = "Cookie", contentType = "Content-Type", accept = "Accept"
    }
    
    /// Sets the cookies to use for a `URLRequest`
    /// - Parameter cookies: An array of cookies that will be used in a `URLRequest`
    mutating func setCookieHeader(for cookies: [HTTPCookie]?) {
        if let cookies = cookies {
            self.setValue(cookies.cookieHeader, forHTTPHeaderField: Header.cookie.rawValue)
        }
    }
}

extension HTTPURLResponse {
    
    /// The status for a `HTTPURLResponse`
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
        
        var description: String {
            String(describing: self)
        }
    }
    
    /// The status of this `HTTPURLResponse`
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
    
    /// Clears all cookies in this cookie store
    /// - Parameter completion: completion function
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
    
    /// Adds the given cookies to the cookie store and removes any other cookies
    /// - Parameters:
    ///   - cookies: The cookies to add to the cookie store
    ///   - completion: completion function
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

extension URLSessionConfiguration {
    
    /// A URLSession that is used for authentication based network requests
    /// - Cookie Store: `HTTPCookieStorage.shared`
    /// - Cache Policy: `reloadIgnoringLocalAndRemoteCacheData`
    /// - Cookie Accept Policy: `always`
    /// - Uses `URLSessionConfiguration.default` for all other configuration
    static let authentication: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.httpCookieAcceptPolicy = .always
        
        return configuration
    }()
    
    /// A URLSession that is used for more secure network requests
    /// - Cookie Store: `HTTPCookieStorage.shared`
    /// - Should Set Cookies: `true`
    /// - Uses `URLSessionConfiguration.ephemeral` for all other configuration
    static let secure: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage = .shared
        return configuration
    }()
    
    /// A URLSession that is used for all API based network requests
    /// - Cookie Store: `HTTPCookieStorage.shared`
    /// - Cache Policy: `reloadIgnoringLocalCacheData`
    /// - Uses `URLSessionConfiguration.default` for all other configuration
    static let dataLoad: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return configuration
    }()
}

extension HTTPCookieStorage {
    
    /// Clears all cookies in HTTPCookieStorage
    func clearCookies() {
        self.removeCookies(since: .distantPast)
    }
    
    /// Gets all cookies that have a given name
    /// - Parameter name: Cookie name to filter by
    /// - Returns: All cookies that have a given name
    func getCookies(name: String) -> [HTTPCookie]? {
        return self.cookies?.filter({$0.name == name})
    }
    
    
    /// Deletes all cookies with a given name
    /// - Parameter name: Cookie name  to filter by
    func deleteCookie(name: String) {
        guard let cookiesToDelete = getCookies(name: name) else {
            return
        }
        cookiesToDelete.forEach { cookie in
            self.deleteCookie(cookie)
        }
    }
}

