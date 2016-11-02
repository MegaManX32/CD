//
//  Language+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation

extension Language {
    
    // MARK: - JSON serialization
    
    func initWith(JSON:Any) -> Language {
        
        guard let dictionary = JSON as? [String : Any]
            else {
                return self
        }
        
        self.name = dictionary["name"] as? String
        self.id = dictionary["id"] as? String
        
        return self
    }
    
    func asJSON() -> [String : String] {
        
        var JSON = [String : String]()
        JSON["name"] = self.name! as String
        JSON["id"] = self.id! as String
        
        return JSON;
    }
}
