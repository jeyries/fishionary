//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation

final class DataManager {

    static let shared = DataManager()

    var database = [Fish]()
    var props = [Property]()


    private init() {
        init_database()
        init_props()

        sortInPlace(language: "english")
    }

    private func init_database() {

        let url = Bundle.main.bundleURL
                    .appendingPathComponent("data/database.json")
        let jsonData = try! Data(contentsOf: url)
        let jsonObject = try! JSONSerialization.jsonObject(with: jsonData)
        let root = jsonObject as! [String: Any]
        let _database = root["database"] as! [[String: Any]]
        
        // debug
        //let name = json["database"][0]["image"].stringValue
        //print("name", name)

        database = [Fish]()
        for object in _database {
            let fish = Fish(fromJSON: object)
            database.append(fish)
        }
        print("loaded \(database.count) fishes")

    }

    private func init_props() {

        let url = Bundle.main.bundleURL
                    .appendingPathComponent("data/props.json")
        let jsonData = try! Data(contentsOf: url)
        let _props = try! JSONDecoder().decode(Props.self, from: jsonData)
        props = _props.props
        for prop in props {
            print("found property : \(prop.name)")
        }
        print("loaded \(props.count) properties")

    }

    private func sortInPlace(language: String){
        database.sort {
            //return $0.name(language) < $1.name(language)
            return $0.name(target: language).localizedCaseInsensitiveCompare($1.name(target: language)) == ComparisonResult.orderedAscending
        }
    }

    
    func filterAnyLanguage(search: String?) -> [MatchResult] {
        
        return database.compactMap { fish in
            fish.match(search: search)
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

    static func search_fish(scientific: String, fishes: [Fish]) -> Int {
        
        var index = 0
        for fish in fishes {
            if fish.name(target: "scientific") == scientific {
                return index
            }
            index += 1
        }
        return -1
    }

    
    
}
