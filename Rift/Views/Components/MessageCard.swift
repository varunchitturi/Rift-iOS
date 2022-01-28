//
//  MessageCard.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import SwiftUI

struct MessageCard: View {
    
    init(_ message: Message? = nil) {
        self.message = message
    }
    
    let message: Message?
    
    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading, spacing: DrawingConstants.textSpacing) {
                    Text(String(displaying: message?.name))
                    Group {
                        if message?.date != nil {
                            Text(DateFormatter.simple.string(from: message!.date!))
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                        else {
                            Text(DateFormatter.simple.string(from: message?.postedTime ?? Date()))
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Rift.DrawingConstants.secondaryForegroundColor)
                    .font(.callout.bold())
            }
            .lineLimit(1)
            .foregroundColor(Rift.DrawingConstants.foregroundColor)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: DrawingConstants.backgroundCornerRadius)
                .fill(Rift.DrawingConstants.backgroundColor)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private enum DrawingConstants {
        static let textSpacing: CGFloat = 5
        static let badgeRadius: CGFloat = 15
        static let backgroundCornerRadius: CGFloat = 15
    }
}

#if DEBUG
struct MessageCard_Previews: PreviewProvider {
    static var previews: some View {
        MessageCard(PreviewObjects.message)
    }
}
#endif
