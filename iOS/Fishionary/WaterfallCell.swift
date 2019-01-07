//
//  WaterfallCell.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

final class WaterfallCell: UICollectionViewCell {
    
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: contentView.bounds)
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(fish: Fish) {
        imageView.image = fish.imageContent()
    }

}
