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
    
    static func findAllLanguages(context: NSManagedObjectContext) -> [Language] {
        let fetchRequest: NSFetchRequest<Language> = Language.fetchRequest()
        return try! context.fetch(fetchRequest)
    }
    
    static func createOrUpdateLanguageWith(JSON:[String : Any], context:NSManagedObjectContext) -> Language {
        
        // fetch Language or create new one
        var language = Language.findLanguageWith(id: JSON["uid"] as! String, context: context)
        language = language ?? Language(context: context)
        language!.initWith(JSON: JSON)
        return language!
    }
    
    static func findLanguageWith(id: String, context:NSManagedObjectContext) -> Language? {
        let fetchRequest: NSFetchRequest<Language> = Language.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.language = JSON["language"] as? String
        self.uid = JSON["uid"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["language"] = self.language
        JSON["uid"] = self.uid
        
        return JSON;
    }
}
