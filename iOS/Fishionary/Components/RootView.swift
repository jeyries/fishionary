//
//  RootView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI
import Combine

struct RootView: View {
    
    enum Modal {
        case none
        case settings
        case gallery
        case info
    }
    
    @EnvironmentObject private var appData: AppData
    
    @State private var showingMenu = false

    @State private var modal = Modal.settings {
        didSet {
            appData.showingModal.toggle()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                FishList()
                NavigationLink(
                    destination: FishDetail(fish: appData.selectedFish),
                    isActive: $appData.showingSelectedFish) {
                    EmptyView() }
            }
            .navigationBarTitle(Text("Fishionary"))
            .navigationBarItems(trailing: menuButton)
            .actionSheet(isPresented: $showingMenu) { actionSheet }
            .sheet(isPresented: $appData.showingModal ) { self.modalView }
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
            buttons: [.default(Text("Settings")) { self.modal = .settings },
                      .default(Text("Gallery")) { self.modal = .gallery },
                      .default(Text("Info")) { self.modal = .info } ])
    }
    
    var modalView: some View {
        ZStack {
            if self.modal == .settings {
                SettingsView()
            }
            if self.modal == .gallery {
                //self.gallery
                GalleryView()
            }
            if self.modal == .info {
                //InfoView()
                CustomWebView(url: Bundle.main.bundleURL
                          .appendingPathComponent("data/info/index.html"))
            }
        }.environmentObject(appData)
    }
    
    
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
             .environmentObject(AppData())
    }
}
