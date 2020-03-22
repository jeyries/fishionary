//
//  InfoView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct InfoView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<InfoView>) -> UIViewController {
        let requestURL = Bundle.main.bundleURL
            .appendingPathComponent("data/info/index.html")
        
        let controller = WebViewController(requestURL: requestURL)
        controller.title = "Informations"
        
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<InfoView>) {
        // nothing here
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
