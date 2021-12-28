//
//  AsyncHandler.swift
//  Rift
//
//  Created by Varun Chitturi on 12/27/21.
//

import Foundation
import SwiftUI

struct DefaultAsyncHandler: ViewModifier {
    
    let asyncState: AsyncState
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
            content
        case .success:
            content
        case .failure(let error):
            ErrorDisplay(error: error, retryAction: retryAction)
        case .loading:
            LoadingView()
        }
    }
}

struct CustomAsyncHandler<IdleContent: View, SuccessContent: View, FailureContent: View, LoadingContent: View>: ViewModifier {
    
    init(asyncState: AsyncState, idleView: (() -> IdleContent)?, successView: (() -> SuccessContent)?, loadingView: (() -> LoadingContent)?, failureView: ((Error) -> FailureContent)? = nil) {
        self.asyncState = asyncState
        self.idleView = idleView
        self.successView = successView
        self.failureView = failureView
        self.loadingView = loadingView
    }

    
    let asyncState: AsyncState
    
    let idleView: (() -> IdleContent)?
    let successView: (() -> SuccessContent)?
    let failureView: ((Error) -> FailureContent)?
    let loadingView: (() -> LoadingContent)?
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
            if idleView != nil {
                idleView!()
            }
            else {
                content
            }
        case .success:
            if successView != nil {
                successView!()
            }
            else {
                content
            }
        case .failure(let error):
            if failureView != nil {
                failureView!(error)
            }
            else {
                ErrorDisplay(error: error, retryAction: nil)
            }
        case .loading:
            if loadingView != nil {
                loadingView!()
            }
            else {
                LoadingView()
            }
        }
    }
}

struct APIAsyncHandler<SuccessContent: View, LoadingContent: View>: ViewModifier {
    
    init(asyncState: AsyncState, successView: (() -> SuccessContent)?, loadingView: (() -> LoadingContent)?, retryAction: ((Error) -> ())?) {
        self.asyncState = asyncState
        self.retryAction = retryAction
        self.successView = successView
        self.loadingView = loadingView
    }
    
    
    let asyncState: AsyncState
    let retryAction: ((Error) -> ())?
    let successView: (() -> SuccessContent)?
    let loadingView: (() -> LoadingContent)?
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
            content
        case .success:
            if successView != nil {
                successView!()
            }
            else {
                content
            }
        case .failure(let error):
            switch error {
                
            case API.APIError.notAuthorized:
                ErrorDisplay("""
                     An authentication error occured
                     Please logout and log back in
                     """,
                             error: error
                )
            case URLError.notConnectedToInternet:
                ErrorDisplay("No Internet Connection",
                             error: error,
                             retryAction: retryAction
                )
            default:
                ErrorDisplay(error: error,
                             retryAction: retryAction
                )
            }
        case .loading:
            if loadingView != nil {
                loadingView!()
            }
            else {
                content
                    .skeletonLoad()
            }
        }
    }
}

extension View {
    func asyncHandler(asyncState: AsyncState, retryAction: ((Error) -> ())? = nil) -> some View{
        modifier(DefaultAsyncHandler(asyncState: asyncState, retryAction: retryAction))
    }
    
    func asyncHandler<IdleContent: View, SuccessContent: View, FailureContent: View, LoadingContent: View>(asyncState: AsyncState, idleView: (() -> IdleContent)? = nil, successView: (() -> SuccessContent)? = nil, loadingView: (() -> LoadingContent)? = nil, failureView: ((Error) -> FailureContent)? = nil) -> some View {
        modifier(CustomAsyncHandler(asyncState: asyncState, idleView: idleView, successView: successView, loadingView: loadingView, failureView: failureView))
    }
    
    func apiHandler<SuccessContent: View, LoadingContent: View>(asyncState: AsyncState, successView: (() -> SuccessContent)? = nil, loadingView: (() -> LoadingContent)? = nil, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(APIAsyncHandler(asyncState: asyncState, successView: successView, loadingView: loadingView, retryAction: retryAction))
    }
    
}
