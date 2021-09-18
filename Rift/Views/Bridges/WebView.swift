//
//  WebView.swift
//  WebView
//
//  Created by Varun Chitturi on 9/10/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let request: URLRequest
    var cookieObserver: WKHTTPCookieStoreObserver?
    
    init(request: URLRequest, cookieObserver: WKHTTPCookieStoreObserver? = nil) {
        self.request = request
        self.cookieObserver = cookieObserver
    }
        
    func makeUIView(context: Context) -> WKWebView  {
        
        let webView = WKWebView()
        webView.clearCookies()
        webView.configuration.websiteDataStore = .nonPersistent()
        if let cookieObserver = cookieObserver {
            webView.configuration.websiteDataStore.httpCookieStore.add(cookieObserver)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            uiView.load(request)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        
        WebView(request: URLRequest(url: URL(string: "https://www.google.com/")!))
    }
}
