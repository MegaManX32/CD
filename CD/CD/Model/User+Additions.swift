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
        var user = User.findUserWith(uid: JSON["uid"] as! String)
        user = user ?? User(context: context)
        user!.initWith(JSON: JSON, context: context)
        return user!
    }
    
    static func findUserWith(uid: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        return try! fetchRequest.execute().first
    }
    
    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any], context: NSManagedObjectContext) {
        
        // update simple properties from JSON
        self.birthDate = JSON["birthDate"] as? NSDate
        self.country = JSON["country"] as? String
        self.email = JSON["email"] as? String
        self.firstName = JSON["firstName"] as? String
        self.hostOption = JSON["hostOption"] as! Bool
        self.lastName = JSON["lastName"] as? String
        self.location = JSON["location"] as? String
        self.notification = JSON["notification"] as! Bool
        self.password = JSON["password"] as? String
        self.phoneNumber = JSON["phoneNumber"] as? String
        self.photoId = JSON["photoId"] as? String
        self.proffesion = JSON["proffesion"] as? String
        self.school = JSON["school"] as? String
        self.sendFeedback = JSON["sendFeedback"] as! Bool
        self.uid = JSON["uid"] as? String
        self.work = JSON["work"] as? String
        self.zipcode = JSON["zipcode"] as? String
        
        // create relationships
        if let interests = JSON["interests"] as? [[String : Any]] {
            for interestJSON in interests {
                self.addToInterests(Interest.createOrUpdateInterestWith(JSON: interestJSON, context: context))
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
            JSON["language"] = languagesArray
        }
        
        return JSON
    }
}
