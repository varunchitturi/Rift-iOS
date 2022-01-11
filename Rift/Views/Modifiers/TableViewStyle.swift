//
//  TableViewStyle.swift
//  Rift
//
//  Created by Varun Chitturi on 9/25/21.
//

import SwiftUI
import UIKit

private struct CustomTableViewStyle: ViewModifier {
    
    init() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func usingCustomTableViewStyle() -> some View {
        modifier(CustomTableViewStyle())
    }
}
