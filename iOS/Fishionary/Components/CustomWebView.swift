//
//  CustomWebView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 28/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI
import WebKit

struct CustomWebView: UIViewRepresentable {
    
    let url: URL
    
    private let navigationDelegate = NavigationDelegate()
    
    func makeUIView(context: UIViewRepresentableContext<CustomWebView>) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = navigationDelegate
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<CustomWebView>) {
        uiView.load(URLRequest(url: url))
    }
    
    class NavigationDelegate: NSObject, WKNavigationDelegate {

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            // open links in Safari
            if navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }

    }

   
}

struct CustomWebView_Previews: PreviewProvider {
    static var previews: some View {
        CustomWebView(url: URL(string: "https://www.example.com")!)
    }
}
