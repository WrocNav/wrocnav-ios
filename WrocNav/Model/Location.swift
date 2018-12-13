//
//  Location.swift
//  WrocNav
//
//  Created by Kacper Raczy on 13.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import CoreLocation

/**
 * Interface for location search results
 */
protocol Location {
    var name: String { get }
    var coordinates: CLLocationCoordinate2D { get }
}

/**
 * Concrete implementation
 */
struct AnyLocation: Location {
    let name: String
    let coordinates: CLLocationCoordinate2D
}
