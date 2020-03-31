//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation

final class DataManager {

    static let shared = DataManager()

    let database: [Fish]
    let props: [Property]

    private init() {
        let language = "english"
        
        self.props = Loader.props
        self.database = Loader.database.sorted {
            let a = $0.name(target: language)
            let b = $1.name(target: language)
            return a.localizedCaseInsensitiveCompare(b) == ComparisonResult.orderedAscending
        }
        
        print("loaded \(database.count) fishes")
 
        for prop in props {
            print("found property : \(prop.name)")
        }
        print("loaded \(props.count) properties")
    }
    
    func filterAnyLanguage(search: String?) -> [FishAndMatch] {
        return database.compactMap { fish in
            let match = fish.match(search: search)
            switch match {
            case .None:
                return nil
            default:
                return FishAndMatch(fish: fish, match: match)
            }
        }
    }
    
    func filter_props() -> [Property]
    {
        return props.filter { prop in
            if (prop.mode > 1) { return false }
            if (prop.name == "synonyms") { return false }
            return true
        }
    }
    
    func search_prop(name: String) -> Property? {
        return props.first { $0.name == name }
    }

    static func search_fish(scientific: String, fishes: [Fish]) -> Int? {
        return fishes.firstIndex { $0.name(target: "scientific") == scientific }
    }

}

private struct Loader {
    
    static var database: [Fish] {
        let url = Bundle.main.bundleURL
            .appendingPathComponent("data/database.json")
        let jsonData = try! Data(contentsOf: url)
        let jsonObject = try! JSONSerialization.jsonObject(with: jsonData)
        let root = jsonObject as! [String: Any]
        let database = root["database"] as! [[String: Any]]
        return database.map { Fish(fromJSON: $0) }
    }
    
    static var props: [Property] {
        let url = Bundle.main.bundleURL
            .appendingPathComponent("data/props.json")
        let jsonData = try! Data(contentsOf: url)
        let props = try! JSONDecoder().decode(Props.self, from: jsonData)
        return props.props
    }
    
}
