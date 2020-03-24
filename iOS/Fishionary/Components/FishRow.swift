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
                .environmentObject(AppData())
            FishRow(fish: objects[1].fish)
                .environmentObject(AppData())
        }
        .previewLayout(.fixed(width: 300, height: 70))

    }
}

