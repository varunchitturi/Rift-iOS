//
//  TabBar.swift
//  Rift
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct TabBar: View {
    @Binding var selected: Tab
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(DrawingConstants.barCornerRadius, corners: [.topLeft, .topRight])
                .foregroundColor(Color("Secondary"))
                .frame(minHeight: DrawingConstants.barMinHeight, idealHeight: DrawingConstants.barIdealHeight, maxHeight: DrawingConstants.barMaxHeight, alignment: .bottom)
                .shadow(color: Color("Tertiary").opacity(DrawingConstants.barShadowOpacity), radius: DrawingConstants.barShadowRadius, x: DrawingConstants.barShadowXOffset, y: DrawingConstants.barShadowYOffset)
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) {tab in
                    Spacer()
                    VStack {
                        tab.icon
                        Text(tab.label)
                            .font(.caption)
                        
                    }
                    .foregroundColor(selected == tab ? Color("Primary") : Color("Quartenary"))
                    .onTapGesture {
                        selected = tab
                    }
                    Spacer()
                }
            }
        }
           
        
    }
    private struct DrawingConstants {
        static let barCornerRadius: CGFloat = 40
        static let barMinHeight: CGFloat = 85
        static let barIdealHeight: CGFloat = 90
        static let barMaxHeight: CGFloat = 90
        static let barShadowOpacity: Double = 0.1
        static let barShadowRadius: CGFloat = 7
        static let barShadowXOffset: CGFloat = 0
        static let barShadowYOffset: CGFloat = -5
    }
    
    enum Tab: String, CaseIterable {
        case courses = "Courses", planner = "Planner", inbox = "Inbox"
        
        var icon: Image {
            switch self {
            case .courses:
                return Image(systemName: "graduationcap.fill")
            case .planner:
                return Image(systemName: "book.fill")
            case .inbox:
                return Image(systemName: "tray.fill")
            }
        }
        
        var label: String {
            self.rawValue
        }
    }

}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selected: .constant(.courses))
            .padding(.top)
            .previewLayout(.sizeThatFits)
        TabBar(selected: .constant(.courses))
            .padding(.top)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
