//
//  RiderList+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 12/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension RiderList {
    
    // MARK: - RiderList CRUD
    
    static func createOrUpdateRiderListWith(JSON:[String : Any], context:NSManagedObjectContext) -> RiderList {
        
        // fetch RiderList or create new one
        var riderList = RiderList.findRiderListWith(uid: JSON["uid"] as! String, context: context)
        riderList = riderList ?? RiderList(context: context)
        riderList!.initWith(JSON: JSON, context: context)
        return riderList!
    }
    
    static func findRiderListWith(uid: String, context: NSManagedObjectContext) -> RiderList? {
        let fetchRequest: NSFetchRequest<RiderList> = RiderList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        return try! context.fetch(fetchRequest).first
    }
    
    /*
     
     @NSManaged public var age: NSNumber?
     @NSManaged public var checkIn: NSDate?
     @NSManaged public var checkOut: NSDate?
     @NSManaged public var city: String?
     @NSManaged public var country: String?
     @NSManaged public var details: String?
     @NSManaged public var gender: String?
     @NSManaged public var uid: String?
     @NSManaged public var userUid: String?
     @NSManaged public var interests: NSSet?
     @NSManaged public var languages: NSSet?
     @NSManaged public var riderListOffers: NSSet?
     @NSManaged public var selectedRiderLIstOffer: RiderListOffer?

     
    */
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any], context: NSManagedObjectContext) {
        
        // update simple properties from JSON
        self.uid = JSON["uid"] as? String ?? self.uid
        self.age = JSON["age"] as? NSNumber ?? self.age
        self.country = JSON["country"] as? String ?? self.country
        self.city = JSON["city"] as? String ?? self.city
        self.checkIn = JSON["checkIn"] as? NSDate ?? self.checkIn
        self.checkOut = JSON["checkOut"] as? NSDate ?? self.checkOut
        self.details = JSON["details"] as? String ?? self.details
        self.gender = JSON["gender"] as? String ?? self.gender
        self.userUid = JSON["userUid"] as? String ?? self.userUid
        
        // create relationships
        
        self.interests = NSSet.init()
        if let interests = JSON["interestList"] as? [[String : Any]] {
            for interestJSON in interests {
                self.addToInterests(Interest.createOrUpdateInterestWith(JSON: interestJSON, context: context))
            }
        }
        
        self.languages = NSSet.init()
        if let languages = JSON["languageList"] as? [[String : Any]] {
            for languageJSON in languages {
                self.addToLanguages(Language.createOrUpdateLanguageWith(JSON: languageJSON, context: context))
            }
        }
        
        self.riderListOffers = NSSet.init()
        if let riderListOffers = JSON["offerList"] as? [[String : Any]] {
            for riderListOfferJSON in riderListOffers {
                self.addToRiderListOffers(RiderListOffer.createOrUpdateRiderListOfferWith(JSON: riderListOfferJSON, context: context))
            }
        }
        
        self.selectedRiderListOffer = nil
        if let selectedRiderListOfferJSON = JSON["selectedOffer"] as? [String : Any] {
            self.selectedRiderListOffer = RiderListOffer.createOrUpdateRiderListOfferWith(JSON: selectedRiderListOfferJSON, context: context)
        }
    }
    
    func asJSON() -> [String : Any] {
        
        // create JSON from properties
        var JSON = [String : Any]()
        JSON["uid"] = self.uid
        JSON["country"] = self.country
        JSON["city"] = self.city
        JSON["age"] = self.age
        JSON["checkIn"] = self.checkIn
        JSON["checkOut"] = self.checkOut
        JSON["details"] = self.details
        JSON["gender"] = self.gender
        JSON["userUid"] = self.userUid
        
        // create relationships
        if let interests = self.interests {
            var interestsArray = [[String : Any]]()
            for interest in interests {
                interestsArray.append((interest as! Interest).asJSON())
            }
            JSON["interestList"] = interestsArray
        }
        
        if let languages = self.languages {
            var languagesArray = [[String : Any]]()
            for language in languages {
                languagesArray.append((language as! Language).asJSON())
            }
            JSON["languageList"] = languagesArray
        }
        
        if let riderListOffers = self.riderListOffers {
            var riderListOffersArray = [[String : Any]]()
            for riderListOffer in riderListOffers {
                riderListOffersArray.append((riderListOffer as! RiderListOffer).asJSON())
            }
            JSON["offerList"] = riderListOffersArray
        }
        
        if let selectedRiderListOffer = self.selectedRiderListOffer {
            JSON["selectedOffer"] = selectedRiderListOffer.asJSON()
        }
        
        return JSON
    }
}
