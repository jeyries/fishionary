//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation
import SwiftyJSON

class Fish {

    var image: String
    var json: JSON!
    var searchTexts: [String]!
    var matchText: String?
    var matchRange: Range<String.Index>?

    init(fromJSON _json: JSON) {

        json = _json
        image = json["image"].stringValue
        
        // build search
        let props = ["english", "scientific", /*"image",*/ /*"synonyms",*/ /*"concern",*/
                     "japanese", "hawaii", "korean", "france", "dutch", "deutsch", "catalan",
                     "espana", "portugal", "italia", "swedish", "danish", "norway", "croatian",
                     "greek", "russian", "turkey", "vietnamese", "mandarin"];
        
        searchTexts = []
        for prop in props {
            for (_, name):(String, JSON) in json[prop] {
                searchTexts.append(name.stringValue.lowercaseString)
            }
        }
    }

    func name(target: String) -> String {
        let names = json[target]
        return names[0].stringValue
    }
    
    func names(target: String) -> [String] {
        let _names = json[target]
        var names = [String]()
        for (_, name):(String, JSON) in _names {
            names.append(name.stringValue)
        }
        return names
    }

    func imageContent() -> UIKit.UIImage {
        //print("imageContent for \(image)")
        let filename = image
        let path = NSBundle.mainBundle().bundleURL
                .URLByAppendingPathComponent("data/database")
                .URLByAppendingPathComponent(filename)
                .path
        let content : UIImage = UIImage(contentsOfFile:path!)!
        return content
    }
    
    func imageSize() -> UIKit.CGSize {
        //print("imageSize for \(image)")
        return imageContent().size
    }
    
    
    func match(search: String?) -> Bool {
        
        self.matchText = nil
        self.matchRange = nil
        
        if (search == nil || search!.isEmpty) {
            return true
        }
        
        let _search = search!.lowercaseString
        
        for name in searchTexts {
            let range = name.rangeOfString(_search)
            if  range != nil {
                self.matchText = name
                self.matchRange = range
                return true
            }
        }
        return false
    }

}
