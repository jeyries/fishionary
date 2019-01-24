//
//  MainStoryboard.swift
//  Fishionary
//
//  Created by Julien Eyries on 24/01/2019.
//  Copyright © 2019 jeyries. All rights reserved.
//

import UIKit

struct MainStoryboard {
    
    static var storyboard: UIStoryboard {
        let bundle = Bundle.main
        return UIStoryboard(name: "Main", bundle: bundle)
    }
    
    static var masterViewController: MasterViewController {
        return storyboard.instantiateViewController(withIdentifier: "master-scene") as! MasterViewController
    }
    
    static var detailViewController: DetailViewController {
        return storyboard.instantiateViewController(withIdentifier: "detail-scene") as! DetailViewController
    }
    
    static var imageViewController: ImageViewController {
        return storyboard.instantiateViewController(withIdentifier: "image-scene") as! ImageViewController
    }
    
    static var settingsViewController: UIViewController {
        return storyboard.instantiateViewController(withIdentifier: "settings-navigation")
    }
}
