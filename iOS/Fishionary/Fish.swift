//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation
import UIKit


struct Fish {

    let image: String
    let json: [String: Any]
    let searchTexts: [String]

    init(fromJSON _json: [String: Any]) {

        json = _json
        image = json["image"] as! String
        
        // build search
        let props = ["english", "scientific", /*"image",*/ /*"synonyms",*/ /*"concern",*/
                     "japanese", "hawaii", "korean", "france", "dutch", "deutsch", "catalan",
                     "espana", "portugal", "italia", "swedish", "danish", "norway", "croatian",
                     "greek", "russian", "turkey", "vietnamese", "mandarin"];
        
        var searchTexts = [String]()
        for prop in props {
            let names = json[prop] as! [String]
            for name in names {
                searchTexts.append(name.lowercased())
            }
        }
        self.searchTexts = searchTexts
    }

    func name(target: String) -> String {
        let names = json[target] as! [String]
        return names.first ?? ""
    }
    
    func names(target: String) -> [String] {
        return json[target] as! [String]
    }
    
    var concern: String? {
        return  """
        NEAR THREATENED   - - -   Lophius gastrophysus: least concern; Lophius vomerinus=Cape Monk, Devil Anglerfish, Baudroie Diable, Baudroie du Cap\r
        Rape del Cabo, Rape Diablo:  <a href=\"http://www.iucnredlist.org/apps/redlist/search\" target=\"_blank\">IUCNRedlist</a>
        """
        ///return json["concern"] as? String
    }
    
}

// UIKit
extension Fish {
    func imageContent() -> UIImage {
        //print("imageContent for \(image)")
        let filename = image
        let path = Bundle.main.bundleURL
                .appendingPathComponent("data/database")
                .appendingPathComponent(filename)
                .path
        let content = UIImage(contentsOfFile: path)!
        return content
    }
    
    func imageSize() -> CGSize {
        //print("imageSize for \(image)")
        return imageContent().size
    }
}

// filtering
struct MatchResult {
    let fish: Fish
    let matchText: String?
    let matchRange: Range<String.Index>?
}

extension Fish {
    func match(search: String?) -> MatchResult? {
        
        if (search == nil || search!.isEmpty) {
            return MatchResult(fish: self, matchText: nil, matchRange: nil)
        }
        
        let _search = search!.lowercased()
        
        for name in searchTexts {
            let range = name.range(of: _search)
            if  range != nil {
                return MatchResult(fish: self, matchText: name, matchRange: range)
            }
        }
        return nil
    }
    
}
