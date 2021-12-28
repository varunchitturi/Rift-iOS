//
//  AsyncUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 12/27/21.
//

import Foundation

enum AsyncState {
    case idle
    case success
    case failure(Error)
    case loading
}
