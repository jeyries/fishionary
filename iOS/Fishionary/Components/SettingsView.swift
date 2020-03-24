//
//  SettingsView.swift
//  Fishionary
//
//  Created by Julien Eyriès on 22/03/2020.
//  Copyright © 2020 jeyries. All rights reserved.
//

import SwiftUI

struct SettingsView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<SettingsView>) -> UIViewController {
        let controller = MainStoryboard.settingsViewController
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<SettingsView>) {
        // nothing here
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
