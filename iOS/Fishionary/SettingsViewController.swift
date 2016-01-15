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
    @IBOutlet weak var targetTextField: UITextField!
    
    var sourcePicker : DownPicker!
    var targetPicker : DownPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        
        //    $select.append( $('<option value="'+prop.name+'">'+prop.header+'</option>') );
        
        let texts = props.map() {
            return $0.header
        }
        
        let source = ConfigManager.sharedInstance.source
        var prop = DataManager.sharedInstance.search_prop(source)
        sourceTextField.text = prop?.header
        
        sourcePicker = DownPicker.init(textField: sourceTextField, withData: texts)
        sourcePicker.addTarget(self, action: "sourceSelected:", forControlEvents: .ValueChanged)
        
        let target = ConfigManager.sharedInstance.target
        prop = DataManager.sharedInstance.search_prop(target)
        targetTextField.text = prop?.header
    
        targetPicker = DownPicker.init(textField: targetTextField, withData: texts)
        targetPicker.addTarget(self, action: "targetSelected:", forControlEvents: .ValueChanged)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            NSNotificationCenter.defaultCenter()
                .postNotificationName("SettingsDone", object: nil)
        }
    }
    

    func sourceSelected(sender: AnyObject) {
        //print("sourceSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getPickerView().selectedRowInComponent(0)
        let value = props[row].name
        print("source = \(value)")
        ConfigManager.sharedInstance.source = value
    }

    func targetSelected(sender: AnyObject) {
        //print("targetSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getPickerView().selectedRowInComponent(0)
        let value = props[row].name
        print("target = \(value)")
        ConfigManager.sharedInstance.target = value
    }

    
    
    
}
