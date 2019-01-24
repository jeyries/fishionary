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
    var objects = [FishAndMatch]()
    
    enum Action {
        case showDetail(fish: Fish)
        case showMenu
    }
    
    var callback: ((Action) -> ())?

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
        let object = objects[indexPath.row]
        cell.configure(fish: object.fish, match: object.match)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        callback?(.showDetail(fish: object.fish))
    }

    // MARK: - Search Controller

    func updateSearchResults(for searchController: UISearchController) {
        update()
    }

    // MARK: - Menu
    
    @objc func showMenu(_ sender: AnyObject) {
        callback?(.showMenu)
    }
    
    // other

    func select_fish(scientific: String) {
        
        let fishes = objects.map { $0.fish }
        guard let row = DataManager.search_fish(scientific: scientific, fishes: fishes) else{
            return
        }

        let path = IndexPath(row: row, section: 0)
        tableView.selectRow(at: path, animated: true, scrollPosition: .middle)
        
        let object = objects[row]
        callback?(.showDetail(fish: object.fish))
    }

    func update() {
        let searchString = searchController.searchBar.text;
        objects = DataManager.shared.filterAnyLanguage(search: searchString)
        tableView.reloadData()
    }
    
}

