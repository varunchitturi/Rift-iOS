//
//  URLUtils.swift
//  URLUtils
//
//  Created by Varun Chitturi on 9/9/21.
//

import Foundation

extension URL {
    mutating func insertPathComponent(after component: String, with path: String) {
        let insertingComponent = component
        var components = self.pathComponents
        for (index, component) in components.enumerated() {
            if component == insertingComponent {
                components.insert(path, at: index+1)
                break
            }
        }
        self.pathComponents.forEach {
            if $0 != "/" {
                self.deleteLastPathComponent()
            }
        }
        components.forEach {
            if $0 != "/" {
                self.appendPathComponent($0)
            }
        }
       
    }
}
