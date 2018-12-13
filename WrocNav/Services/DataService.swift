//
//  DataService.swift
//  WrocNav
//
//  Created by Kacper Raczy on 05.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation
import RxSwift

class DataService {
    // MARK: Singleton instance
    private static var _shared: DataService?
    static var shared: DataService {
        if _shared == nil {
            _shared = DataService()
        }
        
        return _shared!
    }
    
    private let connection: ConnectionManager
    
    init() {
        connection = ConnectionManager()
    }

    func fetchStations() -> Observable<Station> {
        return Observable.create({ (observer) -> Disposable in
            for s in self.stations {
                observer.onNext(s)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func fetchTimeTables() -> Observable<TimeTable> {
        return Observable.create({ (observer) -> Disposable in
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
}

// Some mocked methods
extension DataService {
    fileprivate var stations: [Station] {
        let stations = [
            Station(id: 0, name: "Przystanek 0", latitude: 51.14058982, longitude: 16.95920382, category: .bus),
            Station(id: 1, name: "abcPrzystanek 1", latitude: 51.16218975, longitude: 17.12491458, category: .bus),
            Station(id: 1, name: "Uliczba 2", latitude: 51.14400742, longitude: 16.94969305, category: .bus),
            Station(id: 1, name: "Dworcowa 3", latitude: 51.11387120, longitude: 17.10399465, category: .bus),
            Station(id: 1, name: "Polwro 4", latitude: 51.11727839, longitude: 17.03429734, category: .tram),
            Station(id: 1, name: "Politechniczna 5", latitude: 51.10604560, longitude: 17.04676749, category: .common),
            Station(id: 1, name: "Technicza 6", latitude: 51.09990482, longitude: 17.03388429, category: .tram),
            Station(id: 1, name: "Poli 7", latitude: 51.10840913, longitude: 17.07172068, category: .tram)
        ]
        
        return stations
    }
}
