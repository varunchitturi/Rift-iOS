//
//  InboxDetailModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

/// MVVM model to handle the `InboxDetailView`
struct InboxDetailModel {
    
    /// The body of a given `Message` if available
    var messageBody: String? = nil
    
    /// The `Message` that we are seeing the detail of
    let message: Message
}
