//
//  AppDelegate.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        _ = DataManager.shared
        
        self.window = UIWindow()
        
        let rootView = RootView().environmentObject(AppData())
        window!.rootViewController = UIHostingController(rootView: rootView)
        window!.makeKeyAndVisible()
    }



}

