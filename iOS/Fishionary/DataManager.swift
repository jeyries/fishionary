//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataManager {

    static let sharedInstance = DataManager()

    var database = [Fish]()
    var props = [Property]()
    
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
        print("loaded \(database.count) fishes")
        
        props = [Property]()
        for (_, object):(String, JSON) in json["props"] {
            let prop = Property(fromJSON: object)
            props.append(prop)
            print("found property : \(prop.name)")
        }
        print("loaded \(props.count) properties")

        sortInPlace("english")
    }

    func sortInPlace(language: String){
        database.sortInPlace {
            //return $0.name(language) < $1.name(language)
            return $0.name(language).localizedCaseInsensitiveCompare($1.name(language)) == NSComparisonResult.OrderedAscending
        }
    }

    
    func filterAnyLanguage(let search: String?) -> [Fish] {
        
        return database.filter() {
            let fish = $0
            return fish.match(search)
        }

    }
    
    
    func filter_props() -> [Property]
    {
        return props.filter({ (prop) -> Bool in
            if (prop.mode > 1) {return false}
            
            if (prop.name == "synonyms") {return false}
            
            return true
        })
    }
    
    func search_prop(name: String) -> Property? {
        for prop in props {
            if prop.name == name {
                return prop
            }
        }
        return nil
    }

    static func search_fish(scientific: String, objects: [Fish]) -> Int {
        
        var index = 0
        for fish in objects {
            if fish.name("scientific") == scientific {
                return index
            }
            index += 1
        }
        return -1
    }

    
    
}
