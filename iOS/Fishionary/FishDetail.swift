//
//  DetailView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI



struct FishDetail: View {
    
    var fish: Fish
    
    var body: some View {
        VStack {
            Text("This is \(fish.id)")
            //Text("This is \(fish.imagePath)")
            
            /*
            ImageLoader.shared.load(path: vm.imagePath) { [weak self] image in
                self?.detailImage.image = image
            }*/
            Image(uiImage: UIImage(contentsOfFile: fish.imagePath)!)

        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    static var previews: some View {
        FishDetail(fish: objects[0].fish)
    }
}
