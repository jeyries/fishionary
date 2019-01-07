//
//  WebViewController.swift
//  Fishionary
//
//  Created by Julien on 05/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {

    private var requestURL: URL!
    
    init(requestURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.requestURL = requestURL
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {

        let webView = WKWebView()
        webView.navigationDelegate = self
        
        let request = URLRequest(url: requestURL)
        webView.load(request)
        
        self.view = webView
        
        let button = UIBarButtonItem(barButtonSystemItem: .done ,target: self, action: #selector(dismiss))
        self.navigationItem.rightBarButtonItem = button

    }

    @objc func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
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
