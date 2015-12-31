//
//  FishCell.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

class FishCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(fish: Fish) {
        let source = ConfigManager.sharedInstance.source
        let target = ConfigManager.sharedInstance.target
        
        mainLabel!.text = fish.name(source)
        detailLabel!.text = fish.name(target)
        thumbImageView!.image = fish.imageContent()
        
    }

}
