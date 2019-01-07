//
//  SettingsViewController.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import DownPicker

final class SettingsViewController: UIViewController{

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
        var prop = DataManager.sharedInstance.search_prop(name: source)
        sourceTextField.text = prop?.header
        
        sourcePicker = DownPicker.init(textField: sourceTextField, withData: texts)
        sourcePicker.addTarget(self, action: #selector(sourceSelected), for: .valueChanged)
        
        let target = ConfigManager.sharedInstance.target
        prop = DataManager.sharedInstance.search_prop(name: target)
        targetTextField.text = prop?.header
    
        targetPicker = DownPicker.init(textField: targetTextField, withData: texts)
        targetPicker.addTarget(self, action: #selector(targetSelected), for: .valueChanged)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.dismiss(animated: true) { () -> Void in
            NotificationCenter.default
                .post(name: NSNotification.Name(rawValue: "SettingsDone"), object: nil)
        }
    }
    

    @objc func sourceSelected(_ sender: AnyObject) {
        //print("sourceSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getView().selectedRow(inComponent: 0)
        let value = props[row].name
        print("source = \(value)")
        ConfigManager.sharedInstance.source = value
    }

    @objc func targetSelected(_ sender: AnyObject) {
        //print("targetSelected \(sender)")
        let picker = sender as! DownPicker
        let row = picker.getView().selectedRow(inComponent: 0)
        let value = props[row].name
        print("target = \(value)")
        ConfigManager.sharedInstance.target = value
    }

    
    
    
}
