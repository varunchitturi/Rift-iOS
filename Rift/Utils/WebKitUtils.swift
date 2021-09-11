//
//  WebKitUtils.swift
//  WebKitUtils
//
//  Created by Varun Chitturi on 9/10/21.
//

import Foundation
import WebKit

extension WKWebView {

    func clearCookies() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

