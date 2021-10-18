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
    
    var messageBody: String {
        inboxDetailModel.messageBody
    }
    
    var messageType: Message.MessageType {
        inboxDetailModel.message.type
    }
    
    init(message: Message) {
        inboxDetailModel = InboxDetailModel(message: message)
    }
    
    // MARK: - Intents
    
    func getMessageDetail() {
        API.Messages.getMessageBody(message: inboxDetailModel.message) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    self?.inboxDetailModel.messageBody = body
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
    }
  
}
