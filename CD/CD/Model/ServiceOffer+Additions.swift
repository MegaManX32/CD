//
//  ServiceOffer+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation

extension ServiceOffer {
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) -> ServiceOffer {
        
        self.name = JSON["name"] as? String
        self.desc = JSON["description"] as? String
        self.id = JSON["id"] as? String
        self.photoUrlList = JSON["photoUrlList"] as? [String]
        
        return self
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["name"] = self.name
        JSON["description"] = self.desc
        JSON["id"] = self.id
        JSON["photoUrlList"] = self.photoUrlList
        
        return JSON;
    }

}
