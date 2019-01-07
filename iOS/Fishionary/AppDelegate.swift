//
//  AppDelegate.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let database = DataManager.sharedInstance.database
        print("count= \(database.count)")
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        //let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        //navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
        //return true;
    }

}

