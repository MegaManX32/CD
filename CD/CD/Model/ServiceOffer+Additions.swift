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
        var serviceOffer = ServiceOffer.findServiceOfferWith(id: JSON["id"] as! String)
        serviceOffer = serviceOffer ?? ServiceOffer(context: context)
        serviceOffer!.initWith(JSON: JSON)
        return serviceOffer!
    }
    
    static func findServiceOfferWith(id: String) -> ServiceOffer? {
        let fetchRequest: NSFetchRequest<ServiceOffer> = ServiceOffer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return try! fetchRequest.execute().first
    }

    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.name = JSON["name"] as? String
        self.desc = JSON["description"] as? String
        self.id = JSON["id"] as? String
        self.photoUrlList = JSON["photoUrlList"] as? [String]
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
