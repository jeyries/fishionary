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
    @State var magnification: CGFloat = 1.0
    
    @State var translation: CGPoint = .zero
    @State var drag: CGPoint = .zero
    
    var body: some View {
        image
            .rotationEffect(.degrees(90))
            .scaleEffect(scale * magnification)
            .transformEffect(.init(translationX: translation.x + drag.x, y: translation.y + drag.y))
            .gesture(dragGesture)
            .gesture(magnificationGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in self.drag = value.location - value.startLocation }
            .onEnded { value in self.drag = .zero; self.translation = self.translation + value.location - value.startLocation }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in self.magnification = value.magnitude }
            .onEnded { value in self.magnification = 1; self.scale *= value.magnitude }
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


extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
