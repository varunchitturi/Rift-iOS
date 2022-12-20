//
//  AsyncHandler.swift
//  Rift
//
//  Created by Varun Chitturi on 12/27/21.
//

import Foundation
import Firebase
import SwiftUI

enum LoadingStyle {
    case progressCircle
    case skeleton
}

private struct DefaultAsyncHandler: ViewModifier {
    
    let asyncState: AsyncState
    let loadingStyle: LoadingStyle
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
            switch loadingStyle {
            case .progressCircle:
                VStack {
                    ProgressView("Loading")
                }
            case .skeleton:
                content
                    .skeletonLoad()
            }
        }
    }
}

private struct CustomAsyncHandler<IdleContent: View, SuccessContent: View, FailureContent: View, LoadingContent: View>: ViewModifier {
    
    let asyncState: AsyncState
    let idleView: () -> IdleContent
    let successView: () -> SuccessContent
    let loadingView: () -> LoadingContent
    let failureView: (Error) -> FailureContent
    
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
                     An Authentication Error Occurred
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
    
    let asyncState: AsyncState
    let loadingStyle: LoadingStyle
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
            switch loadingStyle {
            case .progressCircle:
                VStack {
                    ProgressView("Loading")
                }
            case .skeleton:
                content
                    .skeletonLoad()
            }
        }
    }
}

private struct CustomAPIAsyncHandler<SuccessContent: View, LoadingContent: View>: ViewModifier {

    let asyncState: AsyncState
    let successView: () -> SuccessContent
    let loadingView: () -> LoadingContent
    let retryAction: ((Error) -> ())?
    
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
    func asyncHandler(asyncState: AsyncState, loadingStyle: LoadingStyle = .progressCircle,retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(DefaultAsyncHandler(asyncState: asyncState, loadingStyle: loadingStyle, retryAction: retryAction))
    }
    
    func asyncHandler<IdleContent: View, SuccessContent: View, FailureContent: View, LoadingContent: View>(asyncState: AsyncState, idleView: @escaping () -> IdleContent, successView: @escaping () -> SuccessContent, loadingView: @escaping () -> LoadingContent, failureView: @escaping (Error) -> FailureContent) -> some View {
        modifier(CustomAsyncHandler(asyncState: asyncState, idleView: idleView, successView: successView, loadingView: loadingView, failureView: failureView))
    }
    
    func apiHandler(asyncState: AsyncState, loadingStyle: LoadingStyle = .skeleton, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(DefaultAPIAsyncHandler(asyncState: asyncState, loadingStyle: loadingStyle, retryAction: retryAction))
    }
    
    func apiHandler<SuccessContent: View, LoadingContent: View>(asyncState: AsyncState, successView: @escaping () -> SuccessContent, loadingView: @escaping () -> LoadingContent, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(CustomAPIAsyncHandler(asyncState: asyncState, successView: successView, loadingView: loadingView, retryAction: retryAction))
    }
    
    func apiHandler<LoadingContent: View>(asyncState: AsyncState, loadingView: @escaping () -> LoadingContent, retryAction: ((Error) -> ())? = nil) -> some View {
        modifier(CustomAPIAsyncHandler(asyncState: asyncState, successView: {self}, loadingView: loadingView, retryAction: retryAction))
    }
}
