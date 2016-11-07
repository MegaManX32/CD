//
//  Interest+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation

extension Interest {
    
    // MARK: - JSON serialization
    
    func initWith(JSON:Any) -> Interest {
        
        guard let dictionary = JSON as? [String : Any]
            else {
                return self
        }
        
        self.name = dictionary["name"] as? String
        self.desc = dictionary["description"] as? String
        self.id = dictionary["id"] as? String
        self.iconUrl = dictionary["iconUrl"] as? String
        
        return self
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["name"] = self.name
        JSON["description"] = self.desc
        JSON["id"] = self.id
        JSON["iconUrl"] = self.iconUrl
        
        return JSON;
    }

}
