//
//  GalleryViewController.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryCell"

final class GalleryViewController: UICollectionViewController {
    
    let objects = DataManager.shared.filterAnyLanguage(search: nil)

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCell
    
        // Configure the cell
        let result = objects[indexPath.row]
        cell.configure(fish: result.fish)
        return cell
    }
    
    // other stuff
    
    @IBAction func done(sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }

}
