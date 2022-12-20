//
//  WebView.swift
//  WebView
//
//  Created by Varun Chitturi on 9/10/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var request: URLRequest
    var urlObserver: NSObject?
    let initialCookies: [HTTPCookie]
    let dataStore: WKWebsiteDataStore
    
    
    private let webView = WKWebView()
    
    init(request: URLRequest, urlObserver: NSObject? = nil, initialCookies: [HTTPCookie]? = nil, dataStore: WKWebsiteDataStore = .nonPersistent()) {
        self.request = request
        self.urlObserver = urlObserver
        self.initialCookies = initialCookies ?? []
        self.dataStore = dataStore
        
        webView.configuration.websiteDataStore = dataStore
        
        if let urlObserver = urlObserver {
            webView.addObserver(urlObserver, forKeyPath: "URL", options: .new, context: nil)
        }
    }
        
    func makeUIView(context: Context) -> WKWebView  {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.configuration.websiteDataStore.httpCookieStore.useOnlyCookies(from: self.initialCookies) {
            uiView.load(request)
        }
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: ()) {
        uiView.stopLoading()
    }
}

#if DEBUG
struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.google.com/")!), dataStore: .nonPersistent())
    }
}
#endif
