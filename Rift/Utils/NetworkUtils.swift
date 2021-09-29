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

extension WKHTTPCookieStore {
    
    func clearCookies() {
        DispatchQueue.main.async {[weak self] in
            if let self = self {
                self.getAllCookies { cookies in
                    cookies.forEach {self.delete($0)}
                }
            }
        }
    }
    
    func setCookies(with cookies: [HTTPCookie]) {
        DispatchQueue.main.async {
            let waitGroup = DispatchGroup()
            
            cookies.forEach { cookie in
                waitGroup.enter()
                self.setCookie(cookie) {
                    waitGroup.leave()
                }
            }
        }
    }
    
}

enum RequestState {
    case idle
    case loading
    case failure
}
