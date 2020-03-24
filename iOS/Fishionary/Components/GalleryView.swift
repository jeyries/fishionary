//
//  GalleryView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

struct GalleryView: UIViewControllerRepresentable {
    
    @EnvironmentObject private var appData: AppData
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GalleryView>) -> UIViewController {
        let controller = WaterfallViewController()
        let appData = self.appData
        controller.didSelect = { fish in
            let name = fish.name(target: "scientific")
            print("selected \(name)")
            appData.showSelectedFish(fish: fish)
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<GalleryView>) {
        // nothing here
    }
}

struct GalleryView_Previews: PreviewProvider {
    
    static var previews: some View {
        GalleryView()
            .environmentObject(AppData())
    }
}
