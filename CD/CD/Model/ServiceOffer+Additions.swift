//
//  ServiceOffer+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension ServiceOffer {
    
    // MARK: - ServiceOffer CRUD
    
    static func createOrUpdateServiceOfferWith(JSON:[String : Any], context:NSManagedObjectContext) -> ServiceOffer {
        
        // fetch ServiceOffer or create new one
        var serviceOffer = ServiceOffer.findServiceOfferWith(id: JSON["uid"] as! String, context: context)
        serviceOffer = serviceOffer ?? ServiceOffer(context: context)
        serviceOffer!.initWith(JSON: JSON)
        return serviceOffer!
    }
    
    static func findServiceOfferWith(id: String, context:NSManagedObjectContext) -> ServiceOffer? {
        let fetchRequest: NSFetchRequest<ServiceOffer> = ServiceOffer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.name = JSON["name"] as? String ?? self.name
        self.desc = JSON["description"] as? String ?? self.desc
        self.uid = JSON["uid"] as? String ?? self.uid
        self.userUid = JSON["userUid"] as? String ?? self.userUid
        self.photoUrlList = JSON["photoUrlList"] as? [String] ?? self.photoUrlList
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["name"] = self.name
        JSON["description"] = self.desc
        JSON["uid"] = self.uid
        JSON["userUid"] = self.userUid
        JSON["photoUrlList"] = self.photoUrlList
        
        return JSON;
    }

}
