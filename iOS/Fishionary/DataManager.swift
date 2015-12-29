//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataManager {

    static let sharedInstance = DataManager()

    var database = [Fish]()

    init() {

        let path = NSBundle.mainBundle().bundleURL
                    .URLByAppendingPathComponent("data/fishionary.json")
                    .path
        let jsonData = NSData(contentsOfFile: path!)
        let json = JSON(data: jsonData!)

        // debug
        //let name = json["database"][0]["image"].stringValue
        //print("name", name)

        database = [Fish]()
        for (_, object):(String, JSON) in json["database"] {
            let fish = Fish(fromJSON: object)
            database.append(fish)
        }
    }


}
