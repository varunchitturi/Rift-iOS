//
//  InboxDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import SwiftUI

struct InboxDetailView: View {
    
    @ObservedObject var inboxDetailViewModel: InboxDetailViewModel
    
    init(_ message: Message) {
        inboxDetailViewModel = InboxDetailViewModel(message: message)
    }
    // TODO: better this message view. Text should be presented much nicer. Add ability to delete a message
    var body: some View {
        ZStack {
            if inboxDetailViewModel.messageBody != nil {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text(inboxDetailViewModel.messageBody!)
                    }
                    .padding()
                }
            }
            else {
                LoadingView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(inboxDetailViewModel.messageType.rawValue)
        .onAppear {
            inboxDetailViewModel.getMessageDetail()
        }
    }
}

#if DEBUG
struct InboxDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailView(PreviewObjects.message)
    }
}
#endif
