//
//  InboxView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import SwiftUI

struct InboxView: View {
    
    init(viewModel: InboxViewModel) {
        self.inboxViewModel = viewModel
    }
    
    @ObservedObject var inboxViewModel: InboxViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DrawingConstants.cardSpacing) {
                    ForEach(inboxViewModel.messages) { message in
                        NavigationLink(destination: InboxDetailView(message)) {
                            MessageCard(message)
                        }
                    }
                }
                .padding()
            }
            .apiHandler(asyncState: inboxViewModel.networkState, loadingView: {
                InboxLoadingView()
            }, retryAction: { _ in
                inboxViewModel.fetchMessages()
            })
            .navigationTitle(HomeModel.Tab.inbox.label)
            .toolbar {
                ToolbarItem(id: UUID().uuidString) {
                    UserPreferencesSheetToggle()
                        .environmentObject(homeViewModel)
                }
            }
            .logViewAnalytics(self)
        }
    }
    
    private enum DrawingConstants {
        static let cardSpacing: CGFloat = 15
    }
}

private struct InboxLoadingView: View {
    
    var body: some View {
        VStack(spacing: DrawingConstants.cardSpacing) {
            ForEach(0..<DrawingConstants.placeholderCardCount) { _ in
                MessageCard()
            }
        }
        .padding()
        .skeletonLoad()
    }
    
    private enum DrawingConstants {
        static let cardSpacing: CGFloat = 15
        static let placeholderCardCount = 7
    }
}


#if DEBUG
struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView(viewModel: InboxViewModel())
    }
}
#endif
