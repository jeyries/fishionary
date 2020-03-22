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
    
    @State private var showingMenu = false
    @State private var showingModal = false
    @State private var modal = ModalView.Modal.settings
    
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
        .navigationBarTitle(Text("Fishionary"))
        .navigationBarItems(trailing: menuButton)
        .actionSheet(isPresented: $showingMenu) { actionSheet }
        .sheet(isPresented: $showingModal) {
            ModalView(modal: self.modal)
        }
        
    }
    
    var menuButton: some View {
        Button(action: { self.showingMenu.toggle() }) {
            Text("Menu")
        }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Menu"),
            message: nil,
            buttons: [.default(Text("Settings")) { self.modal = .settings; self.showingModal.toggle() },
                      .default(Text("Gallery")) { self.modal = .gallery; self.showingModal.toggle() },
                      .default(Text("Info")) { self.modal = .info; self.showingModal.toggle() } ])
    }
    
}

struct FishList_Previews: PreviewProvider {
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

private struct ModalView: View {
    enum Modal {
        case settings
        case gallery
        case info
    }
    
    var modal: Modal
    
    var body: some View {
        ZStack {
            if self.modal == .settings {
                SettingsView()
            }
            if self.modal == .gallery {
                GalleryView()
            }
            if self.modal == .info {
                InfoView()
            }
        }
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
