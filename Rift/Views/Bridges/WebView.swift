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
    var urlObserver: NSObject?
    let initialCookies: [HTTPCookie]
    
    init(request: URLRequest, cookieObserver: WKHTTPCookieStoreObserver? = nil, urlObserver: NSObject? = nil, initialCookies: [HTTPCookie]? = nil) {
        self.request = request
        self.cookieObserver = cookieObserver
        self.urlObserver = urlObserver
        self.initialCookies = initialCookies ?? []
    }
        
    func makeUIView(context: Context) -> WKWebView  {
        
        let webView = WKWebView()
        webView.configuration.websiteDataStore = .nonPersistent()
        if let cookieObserver = cookieObserver {
            webView.configuration.websiteDataStore.httpCookieStore.add(cookieObserver)
        }
        if let urlObserver = urlObserver {
            webView.addObserver(urlObserver, forKeyPath: "URL", options: .new, context: nil)
        }
        webView.setCookies(for: webView.configuration.websiteDataStore, with: initialCookies)
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
