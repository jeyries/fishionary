//
//  DetailViewModel.swift
//  Fishionary
//
//  Created by Julien Eyries on 23/01/2019.
//  Copyright © 2019 jeyries. All rights reserved.
//

import UIKit

final class DetailViewModel {
    
    private let fish: Fish
    
    convenience init() {
        self.init(fish: DetailViewModel.defaultFish)
    }
    
    init(fish: Fish) {
        self.fish = fish
    }
    
    var title: String {
        let source = ConfigManager.shared.source
        let name = fish.name(target: source)
        let source_prop = DataManager.shared.search_prop(name: source)!
        return "\(name) (\(source_prop.header))"
    }
    
    var name: String {
        let target = ConfigManager.shared.target
        return fish.name(target: target)
    }
    
    var image: UIImage {
        return fish.imageContent()
    }
    
    var concern: NSAttributedString? {
        guard let concern = fish.concern, !concern.isEmpty else { return nil }
        
        let rendering =  """
        <html>
        <style type="text/css">
        body {
        font-family: "-apple-system", "sans-serif";
        font-size: 14px;
        }
        h2 {
        font-size: 17px;
        }
        </style>
        <body>
        <hr>
        <h2>Concern :</h2>
        <p>\(concern)</p>
        </body>
        </html>
        """
        
        let options = [
            NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        return try! NSMutableAttributedString(data: rendering.data(using: .utf8)!,
                                              options: options,
                                              documentAttributes: nil)
    }
    
    var hasConcern: Bool {
        guard let concern = fish.concern, !concern.isEmpty else { return false }
        return true
    }
    
    var target: String {
        let target = ConfigManager.shared.target
        let prop = DataManager.shared.search_prop(name: target)!
        return prop.header
    }
    
    var props: [Property] {
        return DataManager.shared.filter_props()
    }
    
    var targetTexts: [String] {
        return props.map { $0.header }
    }
    
    var names: [String] {
        let target = ConfigManager.shared.target
        return fish.names(target: target)
    }
    
    static var defaultFish: Fish {
        let objects = DataManager.shared.database
        let index = DataManager.search_fish(scientific: "SPARUS AURATA", fishes: objects)!
        return objects[index]
    }
}

