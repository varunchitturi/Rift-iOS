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
    
    let message: String
    let error: Error?
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        if error == nil {
            content
        }
        else {
            Text(message)
                .font(.body)
                .foregroundColor(DrawingConstants.foregroundColor)
            if retryAction != nil {
                Button {
                    retryAction!(error!)
                } label: {
                    Text("Retry")
                }
            }
        }
    }
}

struct APIErrorHandler: ViewModifier {
    // logout here
    let error: Error?
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        if error == nil {
            content
        }
        else {
            let error = error!
            
            switch error {
            case API.APIError.invalidData, API.APIError.invalidLocale, API.APIError.invalidRequest:
                EmptyView()
            case API.APIError.notAuthorized:
                EmptyView()
            case URLError.notConnectedToInternet:
                EmptyView()
            default:
                EmptyView()
            }
        }
    }
}
