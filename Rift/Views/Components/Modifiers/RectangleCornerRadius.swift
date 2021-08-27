//
//  RectangleCornerRadius.swift
//  RectangleCornerRadius
//
//  Created by Varun Chitturi on 8/27/21.
//

import SwiftUI

struct RectangleRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Shape {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RectangleRoundedCorner(radius: radius, corners: corners))
    }
}
