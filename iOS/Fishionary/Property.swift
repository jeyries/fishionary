//
//  Property.swift
//  Fishionary
//
//  Created by Julien on 05/01/16.
//  Copyright © 2016 jeyries. All rights reserved.
//

import Foundation

struct Property: Codable {
    let header: String
    let name: String
    let mode: Int
 }

struct Props: Codable {
    let props: [Property]
}
