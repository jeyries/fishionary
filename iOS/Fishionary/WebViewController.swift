//
//  WebViewController.swift
//  Fishionary
//
//  Created by Julien on 05/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    private var requestURL: NSURL!
    
    init(requestURL: NSURL) {
        super.init(nibName: nil, bundle: nil)
        self.requestURL = requestURL
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {

        let webView = UIWebView()
        webView.delegate = self
        
        let request = NSURLRequest(URL: requestURL)
        webView.loadRequest(request)
        
        self.view = webView
        
        let button = UIBarButtonItem(barButtonSystemItem: .Done ,target: self, action: "dismiss:")
        self.navigationItem.rightBarButtonItem = button

    }

    
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // open links in Safari
        if ( navigationType == .LinkClicked ) {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false;
        }
        
        return true;
    }

}
