//
//  FishRow.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct FishRow: View {
    
    let sourceName: String
    let targetName: String
    let imagePath: String
    
    init(fish: Fish) {
  
        let source = ConfigManager.shared.source
        sourceName = fish.name(target: source)
        
        let target = ConfigManager.shared.target
        targetName = fish.name(target: target)
        
        imagePath = fish.imagePath
        
    }
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(contentsOfFile: imagePath)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 65)
                .padding(10)
            VStack(alignment: .leading) {
                Text(sourceName)
                    .font(.system(size: 17))
                Text(targetName)
                    .font(.system(size: 15))
                    .italic()
            }
            
        }
    }
}

struct FishRow_Previews: PreviewProvider {
    
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    
    static var previews: some View {
        
        Group {
            FishRow(fish: objects[0].fish)
            FishRow(fish: objects[1].fish)
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
    }
}

