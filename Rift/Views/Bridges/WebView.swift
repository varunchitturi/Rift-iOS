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
    @Binding var cookieJar: HTTPCookieStorage
    
    init(request: URLRequest, cookieJar: Binding<HTTPCookieStorage> = .constant(HTTPCookieStorage()), cookieObserver: WKHTTPCookieStoreObserver? = nil) {
        self.request = request
        self.cookieObserver = cookieObserver
        self._cookieJar = cookieJar
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
    @State private static var cookieJar = HTTPCookieStorage()
    static var previews: some View {
        
        WebView(request: URLRequest(url: URL(string: "https://www.google.com/")!), cookieJar: $cookieJar)
    }
}
