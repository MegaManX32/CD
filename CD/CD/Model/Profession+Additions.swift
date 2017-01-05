//
//  Profession+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/28/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension Profession {
    
    // MARK: - Profession CRUD
    
    static func findAllProfessions(context: NSManagedObjectContext) -> [Profession] {
        let fetchRequest: NSFetchRequest<Profession> = Profession.fetchRequest()
        return try! context.fetch(fetchRequest)
    }
    
    static func createOrUpdateProfessionWith(JSON:[String : Any], context:NSManagedObjectContext) -> Profession {
        
        // fetch ServiceOffer or create new one
        var profession = Profession.findProfessionWith(id: JSON["uid"] as! String, context: context)
        profession = profession ?? Profession(context: context)
        profession!.initWith(JSON: JSON)
        return profession!
    }
    
    static func findProfessionWith(id: String, context:NSManagedObjectContext) -> Profession? {
        let fetchRequest: NSFetchRequest<Profession> = Profession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.profession = JSON["profession"] as? String
        self.uid = JSON["uid"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["profession"] = self.profession
        JSON["uid"] = self.uid
        
        return JSON;
    }
}
