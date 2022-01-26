//
//  AsyncHandler.swift
//  Rift
//
//  Created by Varun Chitturi on 12/27/21.
//

import Foundation
import Firebase
import SwiftUI

private struct DefaultAsyncHandler: ViewModifier {
    
    let asyncState: AsyncState
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
            content
        case .success:
            content
        case .failure(let error):
            VStack {
                ErrorDisplay(error: error, retryAction: retryAction)
            }
        case .loading:
            VStack {
                ProgressView("Loading")
            }
        }
    }
}

private struct CustomAsyncHandler<IdleContent: View, SuccessContent: View, FailureContent: View, LoadingContent: View>: ViewModifier {
    
    init(asyncState: AsyncState, idleView: @escaping () -> IdleContent, successView: @escaping () -> SuccessContent, loadingView: @escaping () -> LoadingContent, failureView: @escaping (Error) -> FailureContent) {
        self.asyncState = asyncState
        self.idleView = idleView
        self.successView = successView
        self.failureView = failureView
        self.loadingView = loadingView
    }

    
    let asyncState: AsyncState
    
    let idleView: () -> IdleContent
    let successView: () -> SuccessContent
    let failureView: (Error) -> FailureContent
    let loadingView: () -> LoadingContent
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
           idleView()
        case .success:
            successView()
        case .failure(let error):
            failureView(error)
        case .loading:
            loadingView()
        }
    }
}

private struct APIErrorDisplay: View {
    
    @EnvironmentObject private var applicationViewModel: ApplicationViewModel
    
    init(error: Error, retryAction: ((Error) -> ())? = nil) {
        self.error = error
        self.retryAction = retryAction
    }
    
    
    let error: Error
    let retryAction: ((Error) -> ())?
    
    var body: some View {
        VStack {
            switch error {
            case API.APIError.responseError(_), API.APIError.invalidRedirect:
                ErrorDisplay("""
                     An Authentication Error Occured
                     Please Log Out and Log Back In
                     """,
                             error: error,
                             retryMessage: "Log Out",
                             retryAction: { _ in
                                applicationViewModel.logOut()
                            }
                )
                .onAppear {
                    Crashlytics.crashlytics().record(error: error)
                }
            case is URLError:
                ErrorDisplay("Couldn't Connect to the Internet",
                             error: error,
                             retryAction: retryAction
                )
            default:
                ErrorDisplay(error: error,
                             retryAction: retryAction
                )
                .onAppear {
                    Crashlytics.crashlytics().record(error: error)
                }
            }
        }
    }
}

private struct DefaultAPIAsyncHandler: ViewModifier {
    
    init(asyncState: AsyncState, retryAction: ((Error) -> ())?) {
        self.asyncState = asyncState
        self.retryAction = retryAction
    }
    
    
    let asyncState: AsyncState
    let retryAction: ((Error) -> ())?
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
            content
        case .success:
            content
        case .failure(let error):
            APIErrorDisplay(error: error, retryAction: retryAction)
        case .loading:
            content
                .skeletonLoad()
        }
    }
}

private struct CustomAPIAsyncHandler<SuccessContent: View, LoadingContent: View>: ViewModifier {
    
    init(asyncState: AsyncState, successView: @escaping () -> SuccessContent, loadingView: @escaping () -> LoadingContent, retryAction: ((Error) -> ())?) {
        self.asyncState = asyncState
        self.retryAction = retryAction
        self.successView = successView
        self.loadingView = loadingView
    }
    
    
    let asyncState: AsyncState
    let retryAction: ((Error) -> ())?
    let successView: () -> SuccessContent
    let loadingView: () -> LoadingContent
    
    func body(content: Content) -> some View {
        switch asyncState {
        case .idle:
            content
        case .success:
            successView()
        case .failure(let error):
            APIErrorDisplay(error: error, retryAction: retryAction)
        case .loading:
            loadingView()
        }
    }
}

extension View {
    func asyncHandler(asyncState: AsyncState, retryAction: ((Error) -> ())? = nil) -> some View{
        modifier(DefaultAsyncHandler(asyncState: asyncState, retryAction: retryAction))
    }
    
    func asyncHandler<IdleContent: View, SuccessContent: View, FailureContent: View, LoadingContent: View>(asyncState: AsyncState, idleView: @escaping () -> IdleContent, successView: @escaping () -> SuccessContent, loadingView: @escaping () -> LoadingContent, failureView: @escaping (Error) -> FailureContent) -> some View {
        modifier(CustomAsyncHandler(asyncState: asyncState, idleView: idleView, successView: successView, loadingView: loadingView, failureView: failureView))
    }
    
    func apiHandler(asyncState: AsyncState, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(DefaultAPIAsyncHandler(asyncState: asyncState, retryAction: retryAction))
    }
    
    func apiHandler<SuccessContent: View, LoadingContent: View>(asyncState: AsyncState, successView: @escaping () -> SuccessContent, loadingView: @escaping () -> LoadingContent, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(CustomAPIAsyncHandler(asyncState: asyncState, successView: successView, loadingView: loadingView, retryAction: retryAction))
    }
    
    func apiHandler<LoadingContent: View>(asyncState: AsyncState, loadingView: @escaping () -> LoadingContent, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(CustomAPIAsyncHandler(asyncState: asyncState, successView: {self}, loadingView: loadingView, retryAction: retryAction))
    }
}
