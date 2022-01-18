//
//  InboxDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Firebase
import SwiftUI

struct InboxDetailView: View {
    
    @ObservedObject var inboxDetailViewModel: InboxDetailViewModel
    
    init(_ message: Message) {
        inboxDetailViewModel = InboxDetailViewModel(message: message)
    }
    // TODO: better this message view. Text should be presented much nicer. Add ability to delete a message
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text(inboxDetailViewModel.messageBody ?? "")
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(inboxDetailViewModel.messageType.rawValue)
        .apiHandler(asyncState: inboxDetailViewModel.networkState) {
            InboxDetailLoadingView()
        } retryAction: { _ in
            inboxDetailViewModel.getMessageDetail()
        }
        .onAppear {
            inboxDetailViewModel.getMessageDetail()
        }
        .logViewAnlaytics(self)
    }
}

private struct InboxDetailLoadingView: View {
    
    var body: some View {
        VStack {
            Text(String(repeating: " ", count: DrawingConstants.placeholderTextLength))
            Spacer()
        }
        .padding()
        .skeletonLoad()
    }
    
    private struct DrawingConstants {
        static let placeholderTextLength = 500
    }
}

#if DEBUG
struct InboxDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailView(PreviewObjects.message)
    }
}
#endif
