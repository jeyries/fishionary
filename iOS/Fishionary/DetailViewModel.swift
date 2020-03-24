//
//  DetailViewModel.swift
//  Fishionary
//
//  Created by Julien Eyries on 23/01/2019.
//  Copyright © 2019 jeyries. All rights reserved.
//

import UIKit

struct DetailViewModel {
    
    let fish: Fish
    let source: String
    let target: String
    
    var title: String {
        let name = fish.name(target: source)
        let source_prop = DataManager.shared.search_prop(name: source)!
        return "\(name) (\(source_prop.header))"
    }
    
    var name: String {
        return fish.name(target: target)
    }
    
    var imagePath: String {
        return fish.imagePath
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
    
    var concernLink: URL? {
        return concern?.links.first
    }
    
    var hasConcern: Bool {
        guard let concern = fish.concern, !concern.isEmpty else { return false }
        return true
    }
    
    var targetDescription: String {
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
        return fish.names(target: target)
    }
    
    static var defaultFish: Fish {
        let objects = DataManager.shared.database
        let index = DataManager.search_fish(scientific: "SPARUS AURATA", fishes: objects)!
        return objects[index]
    }
}



private extension NSAttributedString {
    var links: [URL] {
        var links = [URL]()
        self.enumerateAttribute(.link, in: NSRange(0..<self.length), options: []) { value, range, stop in
            if let value = value as? URL {
                links.append(value)
            }
        }
        return links
    }
}



