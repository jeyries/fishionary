//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation
import SwiftyJSON

class Fish {

    var image: String
    var json: JSON!

    init(fromJSON _json: JSON) {

        json = _json
        image = json["image"].stringValue
    }

    func name(target: String) -> String {
        let names = json[target]
        var name: String
        if (target=="english"){
            name = names.stringValue
        } else {
            name = names[0].stringValue
        }
        return name
    }
    
    func names(target: String) -> [String] {
        let _names = json[target]
        var names = [String]()
        if (target=="english"){
            names.append(_names.stringValue)
        } else {
            for (_, name):(String, JSON) in _names {
                names.append(name.stringValue)
            }
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
}
