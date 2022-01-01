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
        case invalidRequest
        case invalidLocale
        case responseError(HTTPURLResponse.Status)
        
        var localizedDescription: String {
            switch self {
            case .invalidData:
                return "No or invalid data was found in the API response."
            case .invalidRequest:
                return "An invalid request was made. Please check your request paramaters."
            case .invalidLocale:
                return "There is no associated district found with this request."
            case .responseError(let status):
                return "Your request could not be completed. HTTP status: \(status.description)"
            }
        }
        
        init?(response: URLResponse?) {
            guard let response = response as? HTTPURLResponse else {
                return nil
            }
            switch response.status {
            case .success, .moved, .found, .notModified:
                return nil
            default:
                self = .responseError(response.status)
            }
        }
       
    }
    
    
    
}
