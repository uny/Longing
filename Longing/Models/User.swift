//
//  User.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import UIKit
import Accounts

let userKey = "user"
let usernameKey = "username"
let uidKey = "uid"

class User {
    var username : String = ""
    var uid : String = ""
    
    // MARK: - Class functions
    /**
    * Login
    */
    class func login() {
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
                    usernameKey: username,
                    uidKey: "\(uid)"
                ]
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(userInfo, forKey: userKey)
                userDefaults.synchronize()
            }
        }
    }
    /**
    * Logout
    */
    class func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userKey)
    }
    // MARK: - Instance functions
    func authenticated() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.objectForKey(userKey) != nil
    }
    
    private func existsAccount() {
        
    }
}
