//
//  City+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/28/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension City {
    
    // MARK: - City CRUD
    
    static func findAllCities(contryID: String, context: NSManagedObjectContext) -> [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"countryUid == %@", contryID)
        return try! context.fetch(fetchRequest)
    }
    
    static func createOrUpdateCityWith(JSON:[String : Any], context:NSManagedObjectContext) -> City {
        
        // fetch ServiceOffer or create new one
        var city = City.findCityWith(id: JSON["uid"] as! String, context: context)
        city = city ?? City(context: context)
        city!.initWith(JSON: JSON)
        return city!
    }
    
    static func findCityWith(id: String, context:NSManagedObjectContext) -> City? {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.cityName = JSON["cityName"] as? String
        self.uid = JSON["uid"] as? String
        self.countryUid = JSON["countryUid"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["cityName"] = self.cityName
        JSON["uid"] = self.uid
        JSON["countryUid"] = self.countryUid
        
        return JSON;
    }

}
