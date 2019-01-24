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
    
    func configure(fish: Fish, match: MatchResult) {
        let source = ConfigManager.shared.source
        let target = ConfigManager.shared.target
        
        mainLabel.text = fish.name(target: source)
        detailLabel.text = fish.name(target: target)
        detailLabel.textColor = .black
        thumbImageView.image = fish.imageContent()
        
        if let attributedString = match.attributedString {
            detailLabel.attributedText = attributedString
        }
    }
    
}


private extension MatchResult {
    var attributedString: NSAttributedString? {
        switch self {
        case .None:
            return nil
        case .All:
            return nil
        case .Some(let text, let range):
            let start: Int = text.distance(from: text.startIndex, to: range.lowerBound)
            let length: Int = text.distance(from: range.lowerBound, to: range.upperBound)
            let attributedString = NSMutableAttributedString(string: text)
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.backgroundColor: UIColor.yellow]
            attributedString.addAttributes(attributes, range: NSMakeRange(start, length))
            return attributedString
        }
    }
}
