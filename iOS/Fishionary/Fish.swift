//
// Created by Julien on 29/12/15.
// Copyright (c) 2015 jeyries. All rights reserved.
//

import Foundation
import UIKit


struct Fish: Identifiable {

    let id = UUID()
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
        return json["concern"] as? String
        /*return  """
        NEAR THREATENED   - - -   Lophius gastrophysus: least concern; Lophius vomerinus=Cape Monk, Devil Anglerfish, Baudroie Diable, Baudroie du Cap\r
        Rape del Cabo, Rape Diablo:  <a href=\"http://www.iucnredlist.org/apps/redlist/search\" target=\"_blank\">IUCNRedlist</a>
        """*/
    }
    
}

// UIKit
extension Fish {
    
    var imagePath: String {
        let filename = image
        return Bundle.main.bundleURL
            .appendingPathComponent("data/database")
            .appendingPathComponent(filename)
            .path
    }
    
    /*
    func imageContent() -> UIImage {
        let content = UIImage(contentsOfFile: imagePath)!
        return content
    }
    
    func imageSize() -> CGSize {
        //print("imageSize for \(image)")
        return imageContent().size
    }*/
}

// filtering
enum MatchResult {
    case None
    case All
    case Some(text: String, range: Range<String.Index>)
}

struct AttributedString {
    static func makeHighlightedText(text: String, range: Range<String.Index>) -> NSAttributedString {
        let start: Int = text.distance(from: text.startIndex, to: range.lowerBound)
        let length: Int = text.distance(from: range.lowerBound, to: range.upperBound)
        let nsrange = NSMakeRange(start, length)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue,
            .backgroundColor: UIColor.yellow]
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(attributes, range: nsrange)
        return attributedString
    }
}

extension Fish {
    func match(search: String?) -> MatchResult {
        
        guard let search = search?.lowercased(), !search.isEmpty else {
            return MatchResult.All
        }
        
        for name in searchTexts {
            if let range = name.range(of: search) {
                return MatchResult.Some(text: name, range: range)
            }
        }
        return MatchResult.None
    }
    
}

struct FishAndMatch {
    let fish: Fish
    let match: MatchResult
}
