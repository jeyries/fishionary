//
//  AppDelegate.swift
//  Fishionary
//
//  Created by Julien on 27/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        let database = DataManager.shared.database
        print("count= \(database.count)")
    }



}

