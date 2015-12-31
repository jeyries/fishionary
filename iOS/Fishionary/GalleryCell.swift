//
//  GalleryCell.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    func configure(fish: Fish) {

        thumbImageView!.image = fish.imageContent()
        
    }
    
}
