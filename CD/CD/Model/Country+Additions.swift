//
//  Country+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/28/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension Country {
    
    // MARK: - Country CRUD
    
    static func findAllCountries(context: NSManagedObjectContext) -> [Country] {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        return try! context.fetch(fetchRequest)
    }
    
    static func createOrUpdateCountryWith(JSON:[String : Any], context:NSManagedObjectContext) -> Country {
        
        // fetch ServiceOffer or create new one
        var country = Country.findCountryWith(id: JSON["uid"] as! String, context: context)
        country = country ?? Country(context: context)
        country!.initWith(JSON: JSON)
        return country!
    }
    
    static func findCountryWith(id: String, context:NSManagedObjectContext) -> Country? {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }

    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.countryName = JSON["countryName"] as? String
        self.uid = JSON["uid"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["countryName"] = self.countryName
        JSON["uid"] = self.uid
        
        return JSON;
    }
}
