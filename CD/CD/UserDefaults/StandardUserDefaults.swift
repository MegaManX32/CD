//
//  StandardUserDefaults.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"

class StandardUserDefaults: NSObject {
    
    static func saveUserID(userID : String) {
        UserDefaults.standard.set(userID, forKey: "userIDKey")
    }
    
    static func userID() -> String {
        return UserDefaults.standard.value(forKey: "userIDKey") as! String
    }
    
    //"yyyy-MM-dd'T'HH:mm:ssZZZ"
    
    static func dateFrom(dateString : String) -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString) as NSDate?
    }
    
    static func stringFrom(date : NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date as Date)
    }

}
