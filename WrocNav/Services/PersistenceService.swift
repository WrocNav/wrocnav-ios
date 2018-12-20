//
//  PersistenceService.swift
//  WrocNav
//
//  Created by Kacper Raczy on 20.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation
import CouchbaseLiteSwift

class PersistenceService {
    
    private let databaseName: String = "wn_local_db"
    private let database: Database
    
    init() throws {
        self.database = try Database(name: databaseName)
    }
    
    func save(value: [String: Any], for key: String) throws {
        let mutable = MutableDocument(id: key, data: value)
        try database.saveDocument(mutable)
    }
    
    func save(model: Model) {
        //database.save
    }
    
    func getValue(for key: String) -> [String: Any]? {
        return nil
    }
    
    func getValue(for key: String) -> Model? {
        return nil
    }
    
}
