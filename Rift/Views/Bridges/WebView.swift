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
    @Binding var cookieJar: HTTPCookieStorage
    
    init(request: URLRequest, cookieJar: Binding<HTTPCookieStorage> = .constant(HTTPCookieStorage())) {
        self.request = request
        self._cookieJar = cookieJar
    }
        
    func makeUIView(context: Context) -> WKWebView  {
        
        let webView = WKWebView()
        webView.clearCookies()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.configuration.websiteDataStore.httpCookieStore.getAllCookies {cookies in
            for cookie in cookies {
                cookieJar.setCookie(cookie)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
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
