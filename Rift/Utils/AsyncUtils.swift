//
//  AsyncUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 12/27/21.
//

import Foundation

/// State of an asynchronous process
enum AsyncState {
    static func == (lhs: AsyncState, rhs: AsyncState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.idle, .idle):
            return true
        case (.success, .success):
            return true
        case (.failure(_), .failure(_)):
            return true
        default:
            return false
        }
    }
    case idle
    case success
    case failure(Error)
    case loading
}
