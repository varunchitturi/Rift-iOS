//
//  InboxView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import SwiftUI

struct InboxView: View {
    
    @ObservedObject var viewModel: InboxViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DrawingConstants.cardSpacing) {
                    ForEach(viewModel.messages) { message in
                        NavigationLink(destination: InboxDetailView(message)) {
                            MessageCard(message)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(HomeModel.Tab.inbox.label)
            .toolbar {
                ToolbarItem(id: UUID().uuidString) {
                    UserPreferencesSheetToggle()
                        .environmentObject(homeViewModel)
                }
            }
        }
    }
    
    private struct DrawingConstants {
        static let cardSpacing: CGFloat = 15
    }
}

#if DEBUG
struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView(viewModel: InboxViewModel())
    }
}
#endif
