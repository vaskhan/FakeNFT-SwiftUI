//
//  WebViewScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 24.09.2025.
//

import SwiftUI
import WebKit

struct WebViewScreen: View {
    @Environment(\.dismiss) private var dismiss
    let urlString: String?
    
    init(urlString: String? = nil) {
        self.urlString = urlString
    }
    
    var body: some View {
        WebView(urlString: urlString)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image("NavigationChevronLeft")
                    }
                }
            }
    }
}

// MARK: - WebView wrapper
struct WebView: UIViewRepresentable {
    let urlString: String?
    
    init(urlString: String? = nil) {
        self.urlString = urlString
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        let defaultURL = "https://practicum.yandex.ru/ios-developer/"
        let urlToLoad = URL(string: urlString ?? defaultURL)!
        web.load(URLRequest(url: urlToLoad))
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
