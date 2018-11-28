//
//  Station.swift
//  WrocNav
//
//  Created by Kacper Raczy on 28.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

struct Station {
    enum Category {
        case bus
        case tram
        case common
    }
    
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let category: Category
}
