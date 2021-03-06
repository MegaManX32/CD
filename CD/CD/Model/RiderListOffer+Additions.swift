//
//  RiderListOffer+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 12/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension RiderListOffer {
    
    // MARK: - RiderListOffer CRUD
    
    static func createOrUpdateRiderListOfferWith(JSON:[String : Any], context:NSManagedObjectContext) -> RiderListOffer {
        
        // fetch Language or create new one
        var riderListOffer = RiderListOffer.findRiderListOfferWith(id: JSON["uid"] as! String, context: context)
        riderListOffer = riderListOffer ?? RiderListOffer(context: context)
        riderListOffer!.initWith(JSON: JSON)
        return riderListOffer!
    }
    
    static func findRiderListOfferWith(id: String, context:NSManagedObjectContext) -> RiderListOffer? {
        let fetchRequest: NSFetchRequest<RiderListOffer> = RiderListOffer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", id)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.uid = JSON["uid"] as? String ?? self.uid
        self.offerorUid = JSON["offerorUid"] as? String ?? self.offerorUid
        self.price = JSON["price"] as? NSNumber ?? self.price
        self.riderListId = JSON["riderListId"] as? String ?? self.riderListId
        self.message = JSON["message"] as? String ?? self.message
        
        // get offeror info
        if let offerorInfoDictionary = JSON["offerorInfo"] as? [String : String] {
            self.offerorFirstName = offerorInfoDictionary["firstName"] ?? self.offerorFirstName
            self.offerorLastName = offerorInfoDictionary["lastName"] ?? self.offerorLastName
            self.offerorCity = offerorInfoDictionary["city"] ?? self.offerorCity
            self.offerorCountry = offerorInfoDictionary["country"] ?? self.offerorCountry
            self.offerorPhotoURL = offerorInfoDictionary["photoURL"] ?? self.offerorPhotoURL
        }
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["uid"] = self.uid
        JSON["offerorUid"] = self.offerorUid
        JSON["price"] = self.price
        JSON["riderListId"] = self.riderListId
        JSON["message"] = self.message
        
        // set offeror info
        var offerorInfoDictionary = [String : String]()
        offerorInfoDictionary["firstName"] = self.offerorFirstName
        offerorInfoDictionary["lastName"] = self.offerorLastName
        offerorInfoDictionary["city"] = self.offerorCity
        offerorInfoDictionary["country"] = self.offerorCountry
        offerorInfoDictionary["photoURL"] = self.offerorPhotoURL
        JSON["offerorInfo"] = offerorInfoDictionary
        
        return JSON;
    }

}
