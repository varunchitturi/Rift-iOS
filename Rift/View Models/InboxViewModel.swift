//
//  InboxViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation
import SwiftUI

class InboxViewModel: ObservableObject {
    
    @Published private var inboxModel: InboxModel = InboxModel()
    @Published var networkState: AsyncState = .idle
    
    var messages: [Message] {
        inboxModel.messages
    }
    
    init() {
        fetchMessages()
    }
    
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
