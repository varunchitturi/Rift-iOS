//
//  InboxDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftUI

/// MVVM view model for the `InboxDetailView`
class InboxDetailViewModel: ObservableObject {
    
    /// MVVM  model
    @Published private var inboxDetailModel: InboxDetailModel
    
    /// `AsyncState` to manage network calls in views
    @Published var networkState: AsyncState = .idle
    
    /// The body oof the `Message` being viewed
    var messageBody: String? {
        inboxDetailModel.messageBody
    }
    
    /// The type of message being viewed
    var messageType: Message.MessageType {
        inboxDetailModel.message.type
    }
    
    /// The title of the message being viewed
    var messageTitle: String {
        inboxDetailModel.message.name
    }
    
    /// The date posted of the message being viewed
    var messageDate: Date? {
        inboxDetailModel.message.date
    }
    
    
    init(message: Message) {
        inboxDetailModel = InboxDetailModel(message: message)
    }
    
    // MARK: - Intents
    
    /// Gets the body of the `Message` from the API
    func getMessageDetail() {
        networkState = .loading
        API.Messages.getMessageBody(message: inboxDetailModel.message) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    self?.inboxDetailModel.messageBody = body
                    self?.networkState = .success
                case .failure(let error):
                    self?.networkState = .failure(error)
                }
            }
        }
    }
  
}
