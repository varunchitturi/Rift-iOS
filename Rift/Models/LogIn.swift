//
//  LogIn.swift
//  LogIn
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation
import SwiftSoup

struct LogIn {
    
    static let samlDOMID = "samlLoginLink"
    
    let locale: Locale
    // TODO: store http cookies in persistent data
    var authCookies = HTTPCookieStorage()
    var ssoUrl: URL?
    var url: URL {
        locale.studentLoginURL
    }
    
    var authUrl: URL {
        locale.districtBaseURL.appendingPathComponent("verify.jsp")
    }
    
    init(locale: Locale) {
        self.locale = locale
        authCookies.cookieAcceptPolicy = .always
    }
    
    func getLogInInfo(completion: @escaping (Result<([HTTPCookie], URL?), Error>)  -> Void)  {
        let url = locale.studentLoginURL
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    }
                    else if let _ = data, let response = response as? HTTPURLResponse, let responseUrL = response.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.allHeaderFields as! [String : String], for: responseUrL)
                        do {
                            let html = try String(contentsOf: url)
                            let htmlDOM = try SwiftSoup.parse(html)
                            let samlURLString: String = (try? htmlDOM.getElementById(LogIn.samlDOMID)?.attr("href")) ?? ""
                            completion(.success((cookies, URL(string: samlURLString))))
                        } catch {
                            completion(.failure(LogInInfoError.errorHTMLRetrieval))
                        }
                    }
                    else {
                        completion(.failure(LogInInfoError.invalidData))
                    }
                }
            }.resume()
    }
    
    enum LogInInfoError: Error {
        case invalidData
        case errorHTMLRetrieval
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Invalid or no data returned from LogIn Info network request"
            case .errorHTMLRetrieval:
                return "Could not retreive HTML from SIS link"
            }
        }
    }
}
