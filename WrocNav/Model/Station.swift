//
//  Station.swift
//  WrocNav
//
//  Created by Kacper Raczy on 28.11.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation
import CoreLocation

struct Station: Location {
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

extension Station {
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Station: Model {
    static var documentType: String {
        return "station"
    }
}
