//
//  ErrorHandler.swift
//  Rift
//
//  Created by Varun Chitturi on 12/10/21.
//

import Foundation
import SwiftUI

struct CustomErrorHandler<V>: ViewModifier where V: View {
    
    let error: Error?
    let errorView: (Error) -> V
    
    func body(content: Content) -> some View {
        if error == nil {
            content
        }
        else {
            errorView(error!)
        }
    }
}

struct DefaultErrorHandler: ViewModifier {
    
    let message: String?
    let error: Error?
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        if error == nil {
            content
        }
        else {
            ErrorDisplay(message: message, error: error, retryAction: retryAction)
        }
    }
}

struct APIErrorHandler: ViewModifier {
    
    let error: Error?
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        if error == nil {
            content
        }
        else {
            let error = error!
            
            switch error {
            case API.APIError.notAuthorized:
                ErrorDisplay(message: """
                     An authentication error occured
                     Please logout and log back in
                     """, error: error)
            case URLError.notConnectedToInternet:
                ErrorDisplay(message: "You are not connected to the internet", error: error, retryAction: retryAction)
            default:
                ErrorDisplay(error: error, retryAction: retryAction)
            }
        }
    }
}

extension View {
    func errorHandler(message: String? = nil, error: Error? = nil, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(DefaultErrorHandler(message: message, error: error, retryAction: retryAction))
    }
    
    func errorHandler<V>(error: Error?, @ViewBuilder errorView: @escaping (Error) -> V) -> some View where V: View {
        modifier(CustomErrorHandler(error: error, errorView: errorView))
    }
    
    func apiErrorHandler(error: Error?, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(APIErrorHandler(error: error, retryAction: retryAction))
    }
}
