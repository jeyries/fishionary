//
//  MasterViewController.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

final class MasterViewController: UITableViewController, UISearchResultsUpdating
    , UIPopoverPresentationControllerDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var detailViewController: DetailViewController? = nil
    var objects = [MatchResult]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Fishionary"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        let button = UIBarButtonItem(title: "Menu", style: .plain ,target: self, action: #selector(showMenu))
        self.navigationItem.rightBarButtonItem = button
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SettingsDone"), object: nil, queue: nil) { [unowned self] _ in
                print("SettingsDone")
                self.update()
        }

        update()
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.vm = DetailViewModel(fish: object.fish)
                //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FishCell", for: indexPath as IndexPath) as! FishCell
        //print("configure row \(indexPath.row)")
        let result = objects[indexPath.row]
        cell.configure(result: result)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    // MARK: - Search Controller

    func updateSearchResults(for searchController: UISearchController) {
        update()
    }

    // MARK: - Menu
    
    @objc func showMenu(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { alert in
            
            let storyboard = UIStoryboard(
                name: "Main",
                bundle: nil)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "Settings")
            
            self.present(
                controller,
                animated: true,
                completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { alert in
            
            let controller = WaterfallViewController()
            let nav = UINavigationController.init(rootViewController: controller)
            
            self.present(
                nav,
                animated: true,
                completion: nil)
            
            controller.didSelect = {
                [unowned self] (fish : Fish) in
                let name = fish.name(target: "scientific")
                print("selected \(name)")
                self.dismiss(animated: true, completion: { () -> Void in
                    self.select_fish(scientific: name)
                })
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Info", style: .default, handler: { alert in
            
            //let requestURL = NSURL(string:"https://www.google.com")!
            let requestURL = Bundle.main.bundleURL
                .appendingPathComponent("data/info/index.html")
            
            let controller = WebViewController(requestURL: requestURL)
            controller.title = "Informations"
      
            let nav = UINavigationController.init(rootViewController: controller)
            
            self.present(
                nav,
                animated: true,
                completion: nil)
            
        }))
        
        
        let popover = alertController.popoverPresentationController
        popover?.permittedArrowDirections = .any
        popover?.delegate = self
        popover?.barButtonItem = sender as? UIBarButtonItem
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // other

    func select_fish(scientific: String) {
        
        let fishes = objects.map { $0.fish }
        guard let row = DataManager.search_fish(scientific: scientific, fishes: fishes) else{
            return
        }

        let path = IndexPath(row: row, section: 0)
        tableView.selectRow(at: path, animated: true, scrollPosition: .middle)
        
        performSegue(withIdentifier: "showDetail", sender: nil)
    }

    func update() {
        let searchString = searchController.searchBar.text;
        objects = DataManager.shared.filterAnyLanguage(search: searchString)
        tableView.reloadData()
    }
    
}

