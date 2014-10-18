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
}
