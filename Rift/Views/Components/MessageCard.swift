//
//  MessageCard.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import SwiftUI

struct MessageCard: View {
    
    init(_ message: Message) {
        self.message = message
    }
    
    let message: Message
    
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading, spacing: DrawingConstants.textSpacing) {
                    Text(message.name)
                    Group {
                        if message.date != nil {
                            Text(DateFormatter.simpleDate.string(from: message.date!))
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                        else {
                            Text(DateFormatter.simpleDate.string(from: message.postedTime))
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(DrawingConstants.secondaryForegroundColor)
                }
                Spacer()
                if message.unread {
                    Circle()
                        .fill(DrawingConstants.badgeColor)
                        .frame(width: DrawingConstants.badgeRadius, height: DrawingConstants.badgeRadius)
                        .padding(.trailing)
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(DrawingConstants.secondaryForegroundColor)
                    .font(.callout.bold())
            }
            .lineLimit(1)
            .foregroundColor(DrawingConstants.foregroundColor)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private struct DrawingConstants {
        static let foregroundColor = Color("Tertiary")
        static let backgroundColor = Color("Secondary")
        static let secondaryForegroundColor = Color("Quartenary")
        static let badgeColor = Color("Background")
        static let textSpacing: CGFloat = 5
        static let badgeRadius: CGFloat = 15
        static let backgroundCornerRadius: CGFloat = 15
    }
}

struct MessageCard_Previews: PreviewProvider {
    static var previews: some View {
        MessageCard(PreviewObjects.message)
    }
}
