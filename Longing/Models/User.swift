//
//  User.swift
//  Longing
//
//  Created by Yuki Nagai on 10/18/14.
//  Copyright (c) 2014 Yuki Nagai. All rights reserved.
//

import Foundation
import Accounts

class User {
    func login() {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        // Prompt the user for permission to their Facebook account stored in the phone's settings
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
            println(granted)
            if granted {
            }
        }
    }
    
    func authenticated() -> Bool {
        return false
    }
    
    private func existsAccount() {
        
    }
}
