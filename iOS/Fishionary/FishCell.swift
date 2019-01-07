//
//  FishCell.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

final class FishCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(result: MatchResult) {
        let source = ConfigManager.sharedInstance.source
        let target = ConfigManager.sharedInstance.target
        
        let fish = result.fish
        mainLabel!.text = fish.name(target: source)
        detailLabel!.text = fish.name(target: target)
        detailLabel!.textColor = .black
        thumbImageView!.image = fish.imageContent()
        
        if (result.matchText != nil) {

            let text = result.matchText!
            let range = result.matchRange!
            let start: Int = text.distance(from: text.startIndex, to: range.lowerBound)
            let length: Int = text.distance(from: range.lowerBound, to: range.upperBound)

            let attributedString = NSMutableAttributedString(string: text)
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.backgroundColor: UIColor.yellow]
            attributedString.addAttributes(attributes, range: NSMakeRange(start, length))
            detailLabel!.attributedText = attributedString
  
        }
        
    }

}
