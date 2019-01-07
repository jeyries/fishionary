//
//  MenuViewController.swift
//  Fishionary
//
//  Created by Julien on 03/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

final class MenuViewController: UITableViewController {
    
    var objects = ["settings", "gallery"]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = objects[indexPath.row]
        return cell
    }


}
