//
//  RectangleCornerStyle.swift
//  RectangleCornerStyle
//
//  Created by Varun Chitturi on 8/27/21.
//

import SwiftUI

private struct RectangleCornerStyle: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RectangleCornerStyle(radius: radius, corners: corners))
    }
}
