//
//  WaterfallCell.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

class WaterfallCell: UICollectionViewCell {
    
    var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: contentView.bounds)
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.contentMode = .ScaleAspectFit
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
