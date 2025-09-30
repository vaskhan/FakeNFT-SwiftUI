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
    
    var body: some View {
        WebView()
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
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        if let url = URL(string: "https://practicum.yandex.ru/ios-developer/") {
            web.load(URLRequest(url: url))
        }
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
