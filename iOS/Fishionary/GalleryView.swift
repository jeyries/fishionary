//
//  GalleryView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI
import UIKit

struct GalleryView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GalleryView>) -> UIViewController {
        let controller = WaterfallViewController()
        controller.didSelect = { fish in
            let name = fish.name(target: "scientific")
            print("selected \(name)")
            /*navigation.dismiss(animated: true) {
                self?.masterViewController.select_fish(scientific: name)
            }*/
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
    }
}
