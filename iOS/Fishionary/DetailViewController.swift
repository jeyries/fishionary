//
//  DetailViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import DownPicker
import Mustache

class DetailViewController: UIViewController, UIWebViewDelegate {
    
    let props = DataManager.sharedInstance.filter_props()

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var detailWebView: UIWebView!

    
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
            let name = fish.name(source)
            let source_prop = DataManager.sharedInstance.search_prop(source)
            
            self.title = String(format: "%@ (%@)"
                ,name
                ,source_prop!.header)
            
            let target = ConfigManager.sharedInstance.target
            
            if let label = self.detailDescriptionLabel {
                label.text = fish.name(target)
            }
            
            if let imageView = self.detailImage {
                let content = fish.imageContent()
                imageView.contentMode = .ScaleAspectFit
                imageView.image = content
            }
            
            if let detailWebView = self.detailWebView {
                //let concern = fish.json["concern"].stringValue
                let concern = "NEAR THREATENED   - - -   Lophius gastrophysus: least concern; Lophius vomerinus=Cape Monk, Devil Anglerfish, Baudroie Diable, Baudroie du Cap\rRape del Cabo, Rape Diablo:  <a href=\"http://www.iucnredlist.org/apps/redlist/search\" target=\"_blank\">IUCNRedlist</a>"
                
                /*
                <p id="detailTextLabel" class="localize">Concern :</p>
                <p id="detailText" class="ui-corner-all" data-role="content"  data-theme="c"></p>
                */
                
                let template = try! Template(string: "<html><body><p>Concern :</p><p>{{{concern}}}</p></body></html>")
                let data = [
                    "concern": concern
                ]
                let rendering = try! template.render(Box(data))
                //print("rendering : \(rendering)")
                detailWebView.delegate = self
                detailWebView.loadHTMLString(rendering, baseURL: nil)
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = UIRectEdge.None // no overlap with navigation bar
        if detailItem == nil {
            let objects = DataManager.sharedInstance.database
            let index = DataManager.search_fish("SPARUS AURATA", objects:objects)
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
        let prop = DataManager.sharedInstance.search_prop(target)
        targetTextField.text = prop?.header
        
        targetPicker = DownPicker.init(textField: targetTextField, withData: texts)
        targetPicker.addTarget(self, action: "targetSelected:", forControlEvents: .ValueChanged)
        
         //setup UITapGestureRecognizer to detect when the user click on the fish ( UIImageView )
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("showImageOnClick:"))
        detailImage.userInteractionEnabled = true
        detailImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            
            let controller = segue.destinationViewController as! ImageViewController
            let image = detailItem?.imageContent()
            controller.image = image
        
        } else if segue.identifier == "showTranslations" {
            
            translationsController = segue.destinationViewController as! TranslationsViewController
            prepareTranslations()
            
        }
    }
    
    // other stuff
    
    func prepareTranslations() {
        if let fish = self.detailItem {
            let names = fish.names(ConfigManager.sharedInstance.target)
            translationsController.objects = names
            
            containerHeight.constant = CGFloat(names.count * 44)
            view.layoutIfNeeded()
        }
    }
    
    func targetSelected(sender: AnyObject) {
        //print("targetSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getPickerView().selectedRowInComponent(0)
        let value = props[row].name
        print("target = \(value)")
        ConfigManager.sharedInstance.target = value
        prepareTranslations()
    }

    
    func showImageOnClick(img: AnyObject)
    {
        print("image tapped")
        performSegueWithIdentifier("showImage", sender: nil)
    }

    
    // MARK: - WebView
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // open links in Safari
        if ( navigationType == .LinkClicked ) {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false;
        }
        
        return true;
    }
}

