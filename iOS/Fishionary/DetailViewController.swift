//
//  DetailViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import WebKit
import DownPicker
import GRMustache

final class DetailViewController: UIViewController, WKNavigationDelegate {
    
    let props = DataManager.sharedInstance.filter_props()

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var detailWebView: WKWebView!
    @IBOutlet weak var detailWebViewHeight: NSLayoutConstraint!

    
    var targetPicker : DownPicker!
    var translationsController : TranslationsViewController!
    
    var detailItem: Fish? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let fish = self.detailItem {
            
            let source = ConfigManager.sharedInstance.source
            let name = fish.name(target: source)
            let source_prop = DataManager.sharedInstance.search_prop(name: source)
            
            self.title = String(format: "%@ (%@)"
                ,name
                ,source_prop!.header)
            
            let target = ConfigManager.sharedInstance.target
            
            if let label = self.detailDescriptionLabel {
                label.text = fish.name(target: target)
            }
            
            if let imageView = self.detailImage {
                let content = fish.imageContent()
                imageView.contentMode = .scaleAspectFit
                imageView.image = content
            }
            
            if let detailWebView = self.detailWebView {
                //let concern = fish.json["concern"] as! String
                let concern = "NEAR THREATENED   - - -   Lophius gastrophysus: least concern; Lophius vomerinus=Cape Monk, Devil Anglerfish, Baudroie Diable, Baudroie du Cap\rRape del Cabo, Rape Diablo:  <a href=\"http://www.iucnredlist.org/apps/redlist/search\" target=\"_blank\">IUCNRedlist</a>"

                if (concern.isEmpty){
                    detailWebView.isHidden = true
                    detailWebViewHeight.constant = 0
                    
                } else {
                    let rendering = NoMustache.render(concern: concern)
                    /*
                    var rendering = ""
                    do {
                        let url = Bundle.main.bundleURL
                            .appendingPathComponent("data/concern.html")
                        let content = try String(contentsOf: url)

                        let template = try GRMustacheTemplate(from: content)
                        let data = [
                                "concern": concern
                        ]
                        rendering = try template.renderObject(data)

                    } catch {

                    }*/

                    print("rendering : \(rendering)")
                    detailWebView.navigationDelegate = self
                    detailWebView.scrollView.isScrollEnabled = false
                    detailWebView.loadHTMLString(rendering, baseURL: nil)
                }
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = [] // no overlap with navigation bar
        if detailItem == nil {
            let objects = DataManager.sharedInstance.database
            let index = DataManager.search_fish(scientific: "SPARUS AURATA", fishes: objects)
            if index >= 0 {
                self.detailItem = objects[index]
            }
        }
        self.configureView()
        
        let props = DataManager.sharedInstance.filter_props()
        let texts = props.map() {
            return $0.header
        }
        
        let target = ConfigManager.sharedInstance.target
        let prop = DataManager.sharedInstance.search_prop(name: target)
        targetTextField.text = prop?.header
        
        targetPicker = DownPicker.init(textField: targetTextField, withData: texts)
        targetPicker.addTarget(self, action: #selector(targetSelected), for: .valueChanged)
        
         //setup UITapGestureRecognizer to detect when the user click on the fish ( UIImageView )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showImageOnClick))
        detailImage.isUserInteractionEnabled = true
        detailImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            
            let controller = segue.destination as! ImageViewController
            let image = detailItem?.imageContent()
            controller.image = image
        
        } else if segue.identifier == "showTranslations" {
            
            translationsController = segue.destination as? TranslationsViewController
            prepareTranslations()
            
        }
    }
    
    // other stuff
    
    func prepareTranslations() {
        if let fish = self.detailItem {
            let names = fish.names(target: ConfigManager.sharedInstance.target)
            translationsController.objects = names
            
            containerHeight.constant = CGFloat(names.count * 44)
            view.layoutIfNeeded()
        }
    }
    
    @objc func targetSelected(_ sender: AnyObject) {
        //print("targetSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getView().selectedRow(inComponent: 0)
        let value = props[row].name
        print("target = \(value)")
        ConfigManager.sharedInstance.target = value
        prepareTranslations()
    }

    
    @objc func showImageOnClick(_ img: AnyObject)
    {
        print("image tapped")
        performSegue(withIdentifier: "showImage", sender: nil)
    }

    
    // MARK: - WebView

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let h = webView.scrollView.contentSize.height
        //print("webview height = \(h)")
        detailWebViewHeight.constant = h
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


struct NoMustache {
    static func render(concern: String) -> String {
        return """
<html>
<style type="text/css">
body {
    font-family: "-apple-system", "sans-serif";
    font-size: 14px;
}
h2 {
    font-size: 17px;
}
</style>
<body>
    <hr>
    <h2>Concern :</h2>
    <p>\(concern)</p>
</body>
</html>
"""
    }
}
