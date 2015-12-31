//
//  MasterViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    var detailViewController: DetailViewController? = nil
    var objects = [Fish]()
    var source = ConfigManager.sharedInstance.source


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }


        objects = DataManager.sharedInstance.filter(source, search: nil)

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



}

