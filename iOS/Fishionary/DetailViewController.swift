//
//  DetailViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import DownPicker

class DetailViewController: UIViewController {
    
    let props = DataManager.sharedInstance.filter_props()

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var targetTextField: UITextField!
    
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
            let target = ConfigManager.sharedInstance.target
            
            if let label = self.detailDescriptionLabel {
                label.text = fish.name(target)
            }
            
            if let imageView = self.detailImage {
                let content = fish.imageContent()
                imageView.contentMode = .ScaleAspectFit
                imageView.image = content
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


}

