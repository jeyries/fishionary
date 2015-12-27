//
//  DetailViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!

    var target = "english"

    var detailItem: JSON? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let fish = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let names = fish[target]
                var name: String
                if (target=="english"){
                    name = names.stringValue
                } else {
                    name = names[0].stringValue
                }
                label.text = name
            }
            if let imageView = self.detailImage {
                let filename = fish["image"].stringValue
                let path = NSBundle.mainBundle().bundleURL
                    .URLByAppendingPathComponent("data/database")
                    .URLByAppendingPathComponent(filename)
                    .path
                let content : UIImage = UIImage(contentsOfFile:path!)!
                imageView.contentMode = .ScaleAspectFit
                imageView.image = content
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

