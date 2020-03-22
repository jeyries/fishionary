//
//  DetailView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI



struct FishDetail: View {
    
    let fish: Fish
    
    @State var showingZoom = false
    
    var body: some View {
        VStack {
            Text("This is \(fish.id)")
            Image(uiImage: UIImage(contentsOfFile: fish.imagePath)!)
                .resizable()
                .aspectRatio(contentMode: .fit)

        }
        .navigationBarItems(trailing: profileButton)
        .sheet(isPresented: $showingZoom) {
            Text("This is \(self.fish.imagePath)")
            /*ProfileHost()
                .environmentObject(self.userData)*/
        }
    }
    
    var profileButton: some View {
        Button(action: { self.showingZoom.toggle() }) {
            Text("View")
        }
    }
    
}

struct DetailView_Previews: PreviewProvider {
    
    static let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    static var previews: some View {
        FishDetail(fish: objects[0].fish)
    }
}
