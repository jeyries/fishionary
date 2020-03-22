//
//  FishRow.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct FishRow: View {
    
    var fish: Fish
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(contentsOfFile: fish.imagePath)!)
                .resizable()
                .frame(width: 50, height: 50)
            Text(fish.id)
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

