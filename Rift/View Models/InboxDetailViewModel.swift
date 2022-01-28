//
//  InboxDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftUI

class InboxDetailViewModel: ObservableObject {
    
    @Published private var inboxDetailModel: InboxDetailModel
    @Published var networkState: AsyncState = .idle
    
    var messageBody: String? {
        inboxDetailModel.messageBody
    }
    
    var messageType: Message.MessageType {
        inboxDetailModel.message.type
    }
    
    var messageTitle: String {
        inboxDetailModel.message.name
    }
    
    var messageDate: Date? {
        inboxDetailModel.message.date
    }
    
    
    init(message: Message) {
        inboxDetailModel = InboxDetailModel(message: message)
    }
    
    // MARK: - Intents
    
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
