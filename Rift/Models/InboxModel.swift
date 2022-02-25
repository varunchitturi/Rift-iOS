//
//  InboxModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

/// MVVM model to handle the `InboxView`
struct InboxModel {
    
    /// List of messages for the user
    /// - Note: These messages don't contain the body of the messages.
    /// They only contain the `URL` to get the message
    var messages: [Message] = []
    
}
