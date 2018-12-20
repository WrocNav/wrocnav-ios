//
//  Model.swift
//  WrocNav
//
//  Created by Kacper Raczy on 20.12.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

protocol Model {
    static var documentType: String  { get }
    //var id: String { get }
}

extension Model {
    func asDocument() -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        for child in mirror.children where child.label != nil {
            result[child.label!] = child.value
        }
        
        return result
    }
}
