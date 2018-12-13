//
//  SearchEngine.swift
//  WrocNav
//
//  Created by Kacper Raczy on 13.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

class SearchEngine<T> {
    private(set) var lookupTable: [String: T]
    private let searchPrefixTree: PrefixTree<Character>
    
    init(lookupTable: [String: T]) {
        self.lookupTable = lookupTable
        self.searchPrefixTree = PrefixTree()
        for key in lookupTable.keys {
            self.searchPrefixTree.insert([Character](key))
        }
    }
    
    func addOrUpdate(key: String, value: T) {
        guard lookupTable[key] == nil else {
            lookupTable[key] = value
            return
        }
        
        lookupTable[key] = value
        searchPrefixTree.insert([Character](key))
    }
    
    func searchWith(prefix string: String) -> [T] {
        let prefixCharacters = [Character](string)
        let keys = searchPrefixTree.lookup(prefix: prefixCharacters)
        return keys.map { lookupTable[String($0)]! }
    }
    
}
