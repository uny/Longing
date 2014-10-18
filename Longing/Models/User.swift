//
//  User.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import Foundation
import Accounts

let userKey = "user"
let usernameKey = "username"
let uidKey = "uid"

class User {
    var username : String = ""
    var uid : String = ""
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let userInfo = userDefaults.dictionaryForKey(userKey) {
            username = userInfo[usernameKey]! as String
            uid = userInfo[uidKey]! as String
        }
    }
    init(username: String, uid: String) {
        self.username = username
        self.uid = uid
    }
    
    // MARK: - Class functions
    /**
    * Login
    */
    class func login(completion: (Bool) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        let options = [
            "ACFacebookAppIdKey": "1534761860073326",
        ]
        // Prompt the user for permission to their Facebook account stored in the phone's settings
        accountStore.requestAccessToAccountsWithType(accountType, options: options) { (granted, error) -> Void in
            if granted {
                let account = accountStore.accountsWithAccountType(accountType).last as ACAccount
                let username = account.username
                let uid = account.valueForKey("properties")["uid"]
                let userInfo = [
                    usernameKey: username as NSString,
                    uidKey: "\(uid!!)" as NSString
                ] as NSDictionary
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(userInfo, forKey: userKey)
                userDefaults.synchronize()
                println(userDefaults.objectForKey(userKey))
            }
            completion(granted)
        }
    }
    /**
    * Logout
    */
    class func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userKey)
    }
    
    // MARK: - Instance functions
    /**
    * Authenticate
    * :returns: Authenticated
    */
    func authenticated() -> Bool {
        // Both not empty
        return username != "" && uid != ""
    }
}
