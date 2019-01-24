//
//  MainMenu.swift
//  Fishionary
//
//  Created by Julien Eyries on 24/01/2019.
//  Copyright © 2019 jeyries. All rights reserved.
//

import UIKit


struct MainMenu {
    
    enum Action {
        case showSettings
        case showGallery
        case showInfo
    }
    
    let callback: ((Action) -> ())?
    
    var alertController: UIAlertController {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { alert in
            self.callback?(.showSettings) }))
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { alert in
            self.callback?(.showGallery) }))
        
        alertController.addAction(UIAlertAction(title: "Info", style: .default, handler: { alert in
            self.callback?(.showInfo) }))
        
        return alertController
    }
    
}

