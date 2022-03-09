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
        ScrollView {
            VStack(spacing: DrawingConstants.sectionSpacing) {
                TextSection(header: "Subject", inboxDetailViewModel.messageTitle)
                TextSection(header: "Date", String(displaying: inboxDetailViewModel.messageDate, formatter: .naturalFull))
                if inboxDetailViewModel.messageBody != nil {
                    let bodyWithFormattedLinks = ""
                    TextSection(header: "Message", inboxDetailViewModel.messageBody!)
                }
            }
            .textSelection(.enabled)
            .padding()
        }
        .apiHandler(asyncState: inboxDetailViewModel.networkState) {
            InboxDetailLoadingView()
        } retryAction: { _ in
            inboxDetailViewModel.getMessageDetail()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(inboxDetailViewModel.messageType.rawValue)
        .onAppear {
            inboxDetailViewModel.getMessageDetail()
        }
        .logViewAnalytics(self)
    }
    
    private enum DrawingConstants {
        static let sectionSpacing: CGFloat = 15
    }
}

private struct InboxDetailLoadingView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: DrawingConstants.sectionSpacing) {
                TextSection(header: "Subject", String.nilDisplay)
                TextSection(header: "Date", String.nilDisplay)
                TextSection(header: "Message", String(repeating: String.nilDisplay, count: DrawingConstants.placeholderTextLength))
            }
            .padding()
            .skeletonLoad()
        }
    }
    
    private enum DrawingConstants {
        static let placeholderTextLength = 500
        static let sectionSpacing: CGFloat = 15
    }
}

#if DEBUG
struct InboxDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InboxDetailView(PreviewObjects.message)
    }
}
#endif
