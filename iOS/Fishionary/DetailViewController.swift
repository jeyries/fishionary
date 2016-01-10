//
//  DetailViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!

    var target = ConfigManager.sharedInstance.target

    var detailItem: Fish? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let fish = self.detailItem {
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
        
        }
    }

}

