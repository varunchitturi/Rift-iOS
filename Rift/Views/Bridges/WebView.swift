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
        webView.configuration.websiteDataStore.httpCookieStore.clearCookies()
        webView.configuration.websiteDataStore.httpCookieStore.setCookies(with: initialCookies)
        if let cookieObserver = cookieObserver {
            webView.configuration.websiteDataStore.httpCookieStore.add(cookieObserver)
        }
        if let urlObserver = urlObserver {
            webView.addObserver(urlObserver, forKeyPath: "URL", options: .new, context: nil)
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
