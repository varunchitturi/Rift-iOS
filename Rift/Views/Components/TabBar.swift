//
//  TabBar.swift
//  Rift
//
//  Created by Varun Chitturi on 8/26/21.
//

import SwiftUI

struct TabBar: View {
    
    struct Clearance: View {
        var body: some View {
            Spacer(minLength: DrawingConstants.barMaxHeight)
        }
    }
    
    @Binding var selected: Tab
    var body: some View {
        // TODO: move tab bar up slighly and make background transparent
        ZStack {
            RoundedRectangle(cornerRadius: .infinity)
                .foregroundColor(DrawingConstants.foregroundColor)
                .frame(minHeight: DrawingConstants.barMinHeight,
                       idealHeight: DrawingConstants.barIdealHeight,
                       maxHeight: DrawingConstants.barMaxHeight,
                       alignment: .bottom)
                .shadow(color: DrawingConstants.backgroundColor
                            .opacity(DrawingConstants.barShadowOpacity),
                        radius: DrawingConstants.barShadowRadius,
                        x: DrawingConstants.barShadowXOffset,
                        y: DrawingConstants.barShadowYOffset)
            HStack{
                ForEach(0..<Tab.allCases.count) {index in
                    let tab = Tab.allCases[index]
                    Spacer()
                    VStack {
                        tab.icon
                        Text(tab.label)
                            .font(.caption)
                        
                    }
                    .foregroundColor(selected == tab ? DrawingConstants.accentColor : DrawingConstants.secondaryForegroundColor)
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
        static let barShadowOpacity: Double = 0.2
        static let barShadowRadius: CGFloat = 13
        static let barShadowXOffset: CGFloat = 0
        static let barShadowYOffset: CGFloat = -2
        static let foregroundColor = Color("Secondary")
        static let accentColor = Color("Primary")
        static let backgroundColor = Color("Tertiary")
        static let secondaryForegroundColor = Color("Quartenary")
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
