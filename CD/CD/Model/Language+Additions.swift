//
//  Language+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension Language {
    
    // MARK: - Language CRUD
    
    static func createOrUpdateLanguageWith(JSON:[String : Any], context:NSManagedObjectContext) -> Language {
        
        // fetch ServiceOffer or create new one
        var language = Language.findLanguageWith(id: JSON["id"] as! String, context: context)
        language = language ?? Language(context: context)
        language!.initWith(JSON: JSON)
        return language!
    }
    
    static func findLanguageWith(id: String, context:NSManagedObjectContext) -> Language? {
        let fetchRequest: NSFetchRequest<Language> = Language.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.name = JSON["name"] as? String
        self.id = JSON["id"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["name"] = self.name
        JSON["id"] = self.id
        
        return JSON;
    }
}
