//
//  MasterViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MasterViewController: UITableViewController, UISearchResultsUpdating
    , UIPopoverPresentationControllerDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var detailViewController: DetailViewController? = nil
    var objects = [Fish]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIBarButtonItem(title: "Menu", style: .Plain ,target: self, action: "showMenu:")
        self.navigationItem.rightBarButtonItem = button
        

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        _ = NSNotificationCenter.defaultCenter()
            .rx_notification("SettingsDone")
            .subscribeNext { [unowned self] _ in
                print("SettingsDone")
                self.update()
        }

        update()
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
        //print("configure row \(indexPath.row)")
        let fish = objects[indexPath.row]
        cell.configure(fish)
        return cell
    }

    // MARK: - Search Controller

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        update()
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
            
            let controller = WaterfallViewController()
            let nav = UINavigationController.init(rootViewController: controller)
            
            self.presentViewController(
                nav,
                animated: true,
                completion: nil)
            
            controller.didSelect = {
                [unowned self] (fish : Fish) in
                let name = fish.name("scientific")
                print("selected \(name)")
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.select_fish(name)
                })
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Info", style: .Default, handler: {(alert :UIAlertAction!) in
            
            //let requestURL = NSURL(string:"https://www.google.com")!
            let requestURL = NSBundle.mainBundle().bundleURL
                .URLByAppendingPathComponent("data/info/index.html")
            
            let controller = WebViewController(requestURL: requestURL)
            controller.title = "Informations"
      
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
    
    // other

    func select_fish(scientific: String) {
        
        let row = DataManager.search_fish(scientific, objects:objects)
        if row < 0 {
            return
        }

        let path = NSIndexPath(forRow: row, inSection: 0)
        tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: .Middle)
        
        performSegueWithIdentifier("showDetail", sender: nil)
    }

    func update() {
        let searchString = searchController.searchBar.text;
        objects = DataManager.sharedInstance.filter(ConfigManager.sharedInstance.source, search: searchString)
        tableView.reloadData()
    }
    
}

