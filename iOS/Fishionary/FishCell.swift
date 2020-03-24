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
    
    private var imageOperation: Operation?
    
    func configure(fish: Fish, match: MatchResult) {
        let source = ConfigManager.shared.source
        let target = ConfigManager.shared.target
        
        mainLabel.text = fish.name(target: source)
        detailLabel.text = fish.name(target: target)
        detailLabel.textColor = .black
        //thumbImageView.image = fish.imageContent()
        
        imageOperation?.cancel()
        thumbImageView.image = nil
        imageOperation = ImageLoader.shared.load(path: fish.imagePath) { [weak self] image in
            self?.thumbImageView.image = image
        }
        
        
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
            return AttributedString.makeHighlightedText(text: text, range: range)
        }
    }
}
