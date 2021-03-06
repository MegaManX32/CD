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
        
        self.serviceName = JSON["serviceName"] as? String ?? self.serviceName
        self.type = JSON["type"] as? String ?? self.type
        self.desc = JSON["description"] as? String ?? self.desc
        self.uid = JSON["uid"] as? String ?? self.uid
        self.userUid = JSON["userUid"] as? String ?? self.userUid
        self.photoUrlList = JSON["photoUrlList"] as? [String] ?? self.photoUrlList
        self.photoIdList = JSON["photoIdList"] as? [String] ?? self.photoIdList
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["serviceName"] = self.serviceName
        JSON["type"] = self.type
        JSON["description"] = self.desc
        JSON["uid"] = self.uid
        JSON["userUid"] = self.userUid
        JSON["photoUrlList"] = self.photoUrlList
        JSON["photoIdList"] =  self.photoIdList
        
        return JSON;
    }

}
