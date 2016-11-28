//
//  Interest+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension Interest {
    
    // MARK: - Interest CRUD
    
    static func createOrUpdateInterestWith(JSON:[String : Any], context:NSManagedObjectContext) -> Interest {
        
        // fetch Interest or create new one
        var interest = Interest.findInterestWith(id: JSON["uid"] as! String, context: context)
        interest = interest ?? Interest(context: context)
        interest!.initWith(JSON: JSON)
        return interest!
    }
    
    static func findInterestWith(id: String, context: NSManagedObjectContext) -> Interest? {
        let fetchRequest: NSFetchRequest<Interest> = Interest.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    static func findAllInterests(context: NSManagedObjectContext) -> [Interest] {
        let fetchRequest: NSFetchRequest<Interest> = Interest.fetchRequest()
        return try! context.fetch(fetchRequest)
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.name = JSON["name"] as? String
        self.desc = JSON["description"] as? String
        self.uid = JSON["uid"] as? String
        self.iconUrl = JSON["iconUrl"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["name"] = self.name
        JSON["description"] = self.desc
        JSON["uid"] = self.uid
        JSON["iconUrl"] = self.iconUrl
        
        return JSON;
    }

}
