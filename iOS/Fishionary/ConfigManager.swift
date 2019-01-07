//
//  ConfigManager.swift
//  Fishionary
//
//  Created by Julien on 31/12/15.
//  Copyright © 2015 jeyries. All rights reserved.
//

import Foundation

final class ConfigManager {
    
    static let sharedInstance = ConfigManager()

    var source = "english"
    var target = "france"
    
    private init() {
        // nothing here
    }
    
}
