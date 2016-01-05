//
//  SettingsViewController.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import DownPicker

class SettingsViewController: UIViewController{

    let props = DataManager.sharedInstance.filter_props()
    
    @IBOutlet weak var sourceTextField: UITextField!
    var sourcePicker : DownPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        
        //    $select.append( $('<option value="'+prop.name+'">'+prop.header+'</option>') );
        
        var texts = [String]()
        for prop in props {
            texts.append(prop.header)
        }
        sourcePicker = DownPicker.init(textField: sourceTextField, withData: texts)
        sourcePicker.addTarget(self, action: "sourceSelected:", forControlEvents: .ValueChanged)
    
        
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func sourceSelected(sender: AnyObject) {
        //print("sourceSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getPickerView().selectedRowInComponent(0)
        let value = props[row].name
        print("source = \(value)")
    }


    
    
    
}
