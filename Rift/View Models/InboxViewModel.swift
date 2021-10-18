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
    
    var messages: [Message] {
        inboxModel.messages
    }
    
    init() {
        API.Messages.getMessageList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.inboxModel.messages = messages
                case .failure(let error):
                    // TODO: better error handling here
                    print(error)
                }
            }
        }
    }

}
