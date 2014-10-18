//
//  Keyword.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import Foundation

let keywordsKey = "keywords"
let keywordsMax = 9

class Keyword {
    
    class func lettersMax() -> Int {
        return 10
    }
    
    class func count() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let keywords = userDefaults.arrayForKey(keywordsKey) {
            return keywords.count
        }
        return 0
    }
    
    class func isFull() -> Bool {
        return keywordsMax <= count()
    }
    
    class func all() -> [String] {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var keywords = userDefaults.arrayForKey(keywordsKey)
        if keywords == nil {
            keywords = [String]()
        }
        return keywords as [String]
    }
    
    class func add(text: String) {
        let trimmed = text.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        if trimmed == "" {
            return
        }
        var keywords = all()
        keywords.append(trimmed)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(keywords, forKey: keywordsKey)
    }
    
    class func removeAt(index : Int) {
        var keywords = all()
        keywords.removeAtIndex(index)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(keywords, forKey: keywordsKey)
    }
}
