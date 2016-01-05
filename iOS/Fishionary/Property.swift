//
//  Property.swift
//  Fishionary
//
//  Created by Julien on 05/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import Foundation
import SwiftyJSON

class Property {
    
    var header: String
    var name: String
    var mode: Int
    
    init(fromJSON json: JSON) {
        
        header = json["header"].stringValue
        name = json["name"].stringValue
        mode = json["mode"].intValue
    }
 }

