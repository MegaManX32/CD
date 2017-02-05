//
//  User+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/1/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    // MARK: - User CRUD
    
    static func createOrUpdateUserWith(JSON:[String : Any], context:NSManagedObjectContext) -> User {
        
        // fetch user or create new one
        var user = User.findUserWith(uid: JSON["uid"] as! String, context: context)
        user = user ?? User(context: context)
        user!.initWith(JSON: JSON, context: context)
        return user!
    }
    
    static func findUserWith(uid: String, context: NSManagedObjectContext) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        return try! context.fetch(fetchRequest).first
    }
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any], context: NSManagedObjectContext) {
        
        // update simple properties from JSON
        self.birthDate = JSON["birthDate"] as? NSDate ?? self.birthDate
        self.country = JSON["country"] as? String ?? self.country
        self.email = JSON["email"] as? String ?? self.email
        self.firstName = JSON["firstName"] as? String ?? self.firstName
        self.hostOption = JSON["hostOption"] as? Bool ?? self.hostOption
        self.lastName = JSON["lastName"] as? String ?? self.lastName
        self.location = JSON["location"] as? String ?? self.location
        self.notification = JSON["notification"] as? Bool ?? self.notification
        self.password = JSON["password"] as? String ?? self.password
        self.phoneNumber = JSON["phoneNumber"] as? String ?? self.phoneNumber
        self.photoId = JSON["photoId"] as? String ?? self.photoId
        self.proffesion = JSON["proffesion"] as? String ?? self.proffesion
        self.school = JSON["school"] as? String ?? self.school
        self.sendFeedback = JSON["sendFeedback"] as? Bool ?? self.sendFeedback
        self.uid = JSON["uid"] as? String ?? self.uid
        self.work = JSON["work"] as? String ?? self.work
        self.zipcode = JSON["zipcode"] as? String ?? self.zipcode
        self.city = JSON["city"] as? String ?? self.city
        self.photoURL = JSON["photoURL"] as? String ?? self.photoURL
        
        // create relationships
        if let interests = JSON["interests"] as? [[String : Any]] {
            self.interests = NSSet.init()
            for interestJSON in interests {
                self.addToInterests(Interest.createOrUpdateInterestWith(JSON: interestJSON, context: context))
            }
        }
        
        if let serviceOffers = JSON["serviceOffers"] as? [[String : Any]] {
            self.serviceOffers = NSSet.init()
            for serviceOfferJSON in serviceOffers {
                self.addToServiceOffers(ServiceOffer.createOrUpdateServiceOfferWith(JSON: serviceOfferJSON, context: context))
            }
        }
        
        if let languages = JSON["languages"] as? [[String : Any]] {
            self.languages = NSSet.init()
            for languageJSON in languages {
                self.addToLanguages(Language.createOrUpdateLanguageWith(JSON: languageJSON, context: context))
            }
        }
    }
    
    func asJSON() -> [String : Any] {
        
        // create JSON from properties
        var JSON = [String : Any]()
        JSON["birthDate"] = self.birthDate
        JSON["country"] = self.country
        JSON["email"] = self.email
        JSON["firstName"] = self.firstName
        JSON["hostOption"] = self.hostOption
        JSON["lastName"] = self.lastName
        JSON["location"] = self.location
        JSON["notification"] = self.notification
        JSON["password"] = self.password
        JSON["phoneNumber"] = self.phoneNumber
        JSON["photoId"] = self.photoId
        JSON["proffesion"] = self.proffesion
        JSON["school"] = self.school
        JSON["sendFeedback"] = self.sendFeedback
        JSON["uid"] = self.uid
        JSON["work"] = self.work
        JSON["zipcode"] = self.zipcode
        JSON["city"] = self.city
        JSON["photoURL"] = self.photoURL
        
        // create relationships
        if let interests = self.interests {
            var interestsArray = [[String : Any]]()
            for interest in interests {
                interestsArray.append((interest as! Interest).asJSON())
            }
            JSON["interests"] = interestsArray
        }
        
        if let offers = self.serviceOffers {
            var offersArray = [[String : Any]]()
            for offer in offers {
                offersArray.append((offer as! ServiceOffer).asJSON())
            }
            JSON["serviceOffers"] = offersArray
        }
        
        if let languages = self.languages {
            var languagesArray = [[String : Any]]()
            for language in languages {
                languagesArray.append((language as! Language).asJSON())
            }
            JSON["languages"] = languagesArray
        }
        
        return JSON
    }
}
