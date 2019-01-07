//
//  TranslationsViewController.swift
//  Fishionary
//
//  Created by Julien on 10/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

final class TranslationsViewController: UITableViewController {
    
    var objects = [String]() {
        didSet {
            // Update the view.
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslationCell", for: indexPath as IndexPath) as! TranslationCell

        // Configure the cell...
        let text = objects[indexPath.row]
        cell.label.text = text
        return cell
    }



}
