//
//  InboxViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftUI

/// MVVM view model for the `InboxView`
class InboxViewModel: ObservableObject {
    
    /// MVVM model
    @Published private var inboxModel: InboxModel = InboxModel()
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .idle
    
    /// List of messages for the user
    var messages: [Message] {
        inboxModel.messages
    }
    
    init() {
        fetchMessages()
    }
    
    /// Gets the list of messages for the user from the API
    func fetchMessages() {
        networkState = .loading
        API.Messages.getMessageList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.inboxModel.messages = messages
                    self?.networkState = .success
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                    self?.networkState = .failure(error)
                }
            }
        }
    }

}
