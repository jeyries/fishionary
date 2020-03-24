//
//  FishRow.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct FishRow: View {
    
    @EnvironmentObject private var appData: AppData
    
    let fish: Fish
    let match: MatchResult
    
    init(object: FishAndMatch) {
        fish = object.fish
        match = object.match
    }
    
    var sourceName: String {
        fish.name(target: appData.source)
    }
    
    var targetName: String {
        fish.name(target: appData.target)
    }
    
    var imagePath: String {
        fish.imagePath
    }
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(contentsOfFile: imagePath)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 65)
                .padding(10)
            VStack(alignment: .leading) {
                Text(fish.id.uuidString).font(.caption)
                Text(sourceName)
                    .font(.system(size: 17))
                    .background(Color(.green))
                detailText.environmentObject(appData)
                CustomLabel(attributedText: detailAttributedString)
            }
            
        }
    }
    
    var detailAttributedString: NSAttributedString {
        switch match {
        case .None, .All:
            return NSAttributedString(string: targetName)
        case .Some(let text, let range):
            return AttributedString.makeHighlightedText(text: text, range: range)
        }
    }
    
    var detailText: some View {
        switch match {
        case .None, .All:
            return AnyView(Text(targetName))
        case .Some(let text, let range):
            return AnyView(HighlightedText(text: text, range: range))
        }
    }
    
}


struct FishRow_Previews: PreviewProvider {
    
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: "daura")
    
    
    static var previews: some View {
        
        Group {
            FishRow(object: objects[0])
                .environmentObject(AppData())
            FishRow(object: objects[1])
                .environmentObject(AppData())
        }
        .previewLayout(.fixed(width: 300, height: 200))

    }
}

private struct HighlightedText: View {
    
    let text: String
    let range: Range<String.Index>
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(text.prefix(upTo: range.lowerBound))
            Text(text[range])
                .foregroundColor(Color(.blue))
                .background(Color(.yellow))
            Text(text.suffix(from: range.upperBound))
        }
    }
}
