//
//  StandardUserDefaults.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class StandardUserDefaults: NSObject {
    
    static func saveUserToken(userToken: String) {
        UserDefaults.standard.set(userToken, forKey:"userToken")
    }
    
    static func userToken() -> String {
        return UserDefaults.standard.value(forKey: "userToken") as! String
    }
    
    static func saveUserID(userID : String) {
        UserDefaults.standard.set(userID, forKey: "userIDKey")
    }
    
    static func userID() -> String {
        return UserDefaults.standard.value(forKey: "userIDKey") as! String
    }
}
