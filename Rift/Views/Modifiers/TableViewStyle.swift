//
//  TableViewStyle.swift
//  Rift
//
//  Created by Varun Chitturi on 9/25/21.
//

import SwiftUI
import UIKit

struct TableViewStyle: ViewModifier {
    
    init() {
        UITableView.appearance().separatorColor = .clear
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func usingCustomTableViewStyle() -> some View {
        modifier(TableViewStyle())
    }
}
