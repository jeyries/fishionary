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
    
    @State var scale: CGFloat = 0.8
    
    var body: some View {
        image
            .rotationEffect(.degrees(90))
            .scaleEffect(scale)
            .gesture(MagnificationGesture()
                .onChanged { value in
                    self.scale = value.magnitude
                }
            )
        /*
        ScrollView {
            image
                .resizable()
                .scaledToFit()
        }*/
    }
}

struct ZoomView_Previews: PreviewProvider {
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    static var image: Image {
        let fish = objects[1].fish
        return Image(uiImage: UIImage(contentsOfFile: fish.imagePath)!)
    }
    
    static var previews: some View {
        ZoomView(image: image)
    }
}
