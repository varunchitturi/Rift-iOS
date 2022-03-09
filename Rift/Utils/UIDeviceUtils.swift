//
//  UIDeviceUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 10/1/21.
//

import Foundation
import UIKit

extension UIDevice {
    
    /// A unique device ID used to identify devices in analytics or network requests
    static var currentDeviceID: String {
        UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
}
