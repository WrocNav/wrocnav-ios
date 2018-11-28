//
//  Foundation+Extensions.swift
//  UtilityKit
//
//  Created by Kacper Raczy on 07.12.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import Foundation

func readPlist(name: String, bundle: Bundle = Bundle.main) -> [String:Any] {
    let plistPath = bundle.path(forResource: name, ofType: "plist")!
    let plistXML = FileManager.default.contents(atPath: plistPath)!
    var plistFormat = PropertyListSerialization.PropertyListFormat.xml
    var plistData = [String:Any]()
    
    do {
        plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &plistFormat) as! [String:Any]
    }catch {
        log.error(error.localizedDescription)
    }
    
    return plistData
}

extension NSPointerArray {
    func addObject(_ object: AnyObject?) {
        guard let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
    
    func insertObject(_ object: AnyObject?, at index: Int) {
        guard index < count, let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
    
    func replaceObject(at index: Int, withObject object: AnyObject?) {
        guard index < count, let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
    
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
    
    func removeObject(at index: Int) {
        guard index < count else { return }
        
        removePointer(at: index)
    }
}

extension DateFormatter {
    static var iso8601: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return df
    }
    
    static var yyyyMMdd: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .iso8601)
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        
        return df
    }
}

extension Decimal {
    static func fromString(string: String) -> Decimal? {
        let locale = Locale(identifier: "en_US_POSIX")
        let dec = Decimal(string: string, locale: locale)
        
        return dec
    }
}

extension Double {
    var toDate: Date {
        return Date(timeIntervalSince1970: self)
    }
}
