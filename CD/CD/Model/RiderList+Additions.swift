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
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any], context: NSManagedObjectContext) {
        
        // update simple properties from JSON
        self.uid = JSON["uid"] as? String ?? self.uid
        self.country = JSON["country"] as? String ?? self.country
        self.city = JSON["city"] as? String ?? self.city
        self.details = JSON["details"] as? String ?? self.details
        self.desc = JSON["description"] as? String ?? "WARNING ASSERTION - NO DESCRIPTION RETURNED FROM SERVER"
        self.gender = JSON["gender"] as? String ?? self.gender
        self.userUid = JSON["userUid"] as? String ?? self.userUid
        
        // age range
        if let ageRangeDictionary = JSON["ageRange"] as? [String : NSNumber] {
            self.ageRangeFrom = ageRangeDictionary["from"] ?? self.ageRangeFrom
            self.ageRangeTo = ageRangeDictionary["to"] ?? self.ageRangeTo
        }
        
        // check in and check out
        if let checkInDateString = JSON["checkIn"] as? String, let checkOutDateString = JSON["checkOut"] as? String {
            self.checkIn = StandardDateFormatter.dateFrom(dateString: checkInDateString)
            self.checkOut = StandardDateFormatter.dateFrom(dateString: checkOutDateString)
        }

        // create relationships
        
        if let interests = JSON["interestList"] as? [[String : Any]] {
            self.interests = NSSet.init()
            for interestJSON in interests {
                self.addToInterests(Interest.createOrUpdateInterestWith(JSON: interestJSON, context: context))
            }
        }
        
        if let languages = JSON["languageList"] as? [[String : Any]] {
            self.languages = NSSet.init()
            for languageJSON in languages {
                self.addToLanguages(Language.createOrUpdateLanguageWith(JSON: languageJSON, context: context))
            }
        }
        
        if let riderListOffers = JSON["offerList"] as? [[String : Any]] {
            self.riderListOffers = NSSet.init()
            for riderListOfferJSON in riderListOffers {
                self.addToRiderListOffers(RiderListOffer.createOrUpdateRiderListOfferWith(JSON: riderListOfferJSON, context: context))
            }
        }
        
//        self.selectedRiderListOffer = nil
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
        JSON["checkIn"] = self.checkIn
        JSON["checkOut"] = self.checkOut
        JSON["details"] = self.details
        JSON["description"] = self.desc
        JSON["gender"] = self.gender
        JSON["userUid"] = self.userUid
        
        // age range
        if let ageRangeFrom = self.ageRangeFrom, let ageRangeTo = self.ageRangeTo {
            var ageRangeDictionary = [String : NSNumber]()
            ageRangeDictionary["from"] = ageRangeFrom
            ageRangeDictionary["to"] = ageRangeTo
            JSON["ageRange"] = ageRangeDictionary
        }
        
        // check in and check out
        if let checkInDate = self.checkIn, let checkOutDate = self.checkOut {
            JSON["checkIn"] = StandardDateFormatter.stringFrom(date: checkInDate)
            JSON["checkOut"] = StandardDateFormatter.stringFrom(date: checkOutDate)
        }
        
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
