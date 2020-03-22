//
//  MasterView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI


struct FishList: View {
    
    let objects: [FishAndMatch] = DataManager.shared.filterAnyLanguage(search: nil)
    
    var body: some View {
        List {
            ForEach(objects) { object in
                NavigationLink(
                    destination: FishDetail(fish: object.fish)
                ) {
                    FishRow(fish: object.fish)
                }
            }
        }
        .navigationBarTitle(Text("Master"))
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FishList()
        }
    }
}

extension Fish: Identifiable {
    var id: String {
        return self.name(target: "scientific")
    }
}

extension FishAndMatch: Identifiable {
    var id: String {
        return self.fish.id
    }
}

/*

 struct LandmarkList: View {
     @EnvironmentObject private var userData: UserData
     
     var body: some View {
         List {
             Toggle(isOn: $userData.showFavoritesOnly) {
                 Text("Show Favorites Only")
             }
             
             ForEach(userData.landmarks) { landmark in
                 if !self.userData.showFavoritesOnly || landmark.isFavorite {
                     NavigationLink(
                         destination: LandmarkDetail(landmark: landmark)
                     ) {
                         LandmarkRow(landmark: landmark)
                     }
                 }
             }
         }
         .navigationBarTitle(Text("Landmarks"))
     }
 }

 struct LandmarksList_Previews: PreviewProvider {
     static var previews: some View {
         ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
             NavigationView {
                 LandmarkList()
                     .previewDevice(PreviewDevice(rawValue: deviceName))
                     .previewDisplayName(deviceName)
             }
         }
         .environmentObject(UserData())
     }
 }

 */
