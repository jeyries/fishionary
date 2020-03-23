//
//  ZoomView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 23/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct ZoomView: View {
    let image: Image
    var body: some View {
        ScrollView {
            image
                .resizable()
                .scaledToFit()
        }
    }
}

struct ZoomView_Previews: PreviewProvider {
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    static var image: Image {
        let fish = objects[0].fish
        return Image(uiImage: UIImage(contentsOfFile: fish.imagePath)!)
    }
    
    static var previews: some View {
        ZoomView(image: image)
    }
}
