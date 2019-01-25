//
//  GalleryCell.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

final class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    private var imageOperation: Operation?
    
    func configure(fish: Fish) {
        imageOperation?.cancel()
        thumbImageView.image = nil
        imageOperation = ImageLoader.shared.load(path: fish.imagePath) { [weak self] image in
            self?.thumbImageView.image = image
        }
    }
    
}
