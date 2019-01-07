//
//  WaterfallFooter.swift
//  Fishionary
//
//  Created by Julien on 04/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import UIKit

final class WaterfallFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
