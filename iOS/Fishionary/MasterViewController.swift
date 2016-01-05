//
//  MasterViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating
    , UIPopoverPresentationControllerDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var detailViewController: DetailViewController? = nil
    var objects = [Fish]()
    var source = ConfigManager.sharedInstance.source


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIBarButtonItem(title: "Menu", style: .Plain ,target: self, action: "showMenu:")
        self.navigationItem.rightBarButtonItem = button
        

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }


        objects = DataManager.sharedInstance.filter(source, search: nil)
        print("loaded \(objects.count) objects")
        
        /*
        detailViewController?.detailItem = objects[0]
        
        // search for "SPARUS AURATA"
        for fish in objects {
            if fish.name("scientific") == "SPARUS AURATA" {
                detailViewController?.detailItem = fish
                break
            }
        }
        */

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
       
    }



    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FishCell", forIndexPath: indexPath) as! FishCell

        let fish = objects[indexPath.row]
        cell.configure(fish)
        return cell
    }

    // MARK: - Search Controller

    func updateSearchResultsForSearchController(searchController: UISearchController) {

        let searchString = searchController.searchBar.text;
        objects = DataManager.sharedInstance.filter(source, search: searchString)
        tableView.reloadData()
    }

    // MARK: - Menu
    
    func showMenu(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Settings", style: .Default, handler: {(alert :UIAlertAction!) in
            
            let storyboard = UIStoryboard(
                name: "Main",
                bundle: nil)
            
            let controller = storyboard.instantiateViewControllerWithIdentifier("Settings")
            
            self.presentViewController(
                controller,
                animated: true,
                completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: .Default, handler: {(alert :UIAlertAction!) in
            
            let storyboard = UIStoryboard(
                name: "Main",
                bundle: nil)
            
            let controller = storyboard.instantiateViewControllerWithIdentifier("Gallery")
            
            self.presentViewController(
                controller,
                animated: true,
                completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Waterfall", style: .Default, handler: {(alert :UIAlertAction!) in
            
            let controller = WaterfallViewController()
            let nav = UINavigationController.init(rootViewController: controller)
            
            self.presentViewController(
                nav,
                animated: true,
                completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Info", style: .Default, handler: {(alert :UIAlertAction!) in
            
            //let requestURL = NSURL(string:"https://www.google.com")!
            let requestURL = NSBundle.mainBundle().bundleURL
                .URLByAppendingPathComponent("data/info/index.html")
            
            let controller = WebViewController(requestURL: requestURL)
      
            let nav = UINavigationController.init(rootViewController: controller)
            
            self.presentViewController(
                nav,
                animated: true,
                completion: nil)
            
        }))
        
        
        let popover = alertController.popoverPresentationController
        popover?.permittedArrowDirections = .Any
        popover?.delegate = self
        popover?.barButtonItem = sender as? UIBarButtonItem
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
}

