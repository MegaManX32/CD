//
//  User+Additions.swift
//  CD
//
//  Created by Vladislav Simovic on 11/1/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import Foundation

extension User {
    
    // MARK: - JSON serialization
    
    func initWith(JSON:Any) {
        
        guard let dictionary = JSON as? [String : Any]
            else {
                return
        }
        
        // update simple properties from JSON
        self.birthDate = dictionary["birthDate"] as? NSDate
        self.country = dictionary["country"] as? String
        self.email = dictionary["email"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.hostOption = dictionary["hostOption"] as! Bool
        self.lastName = dictionary["lastName"] as? String
        self.location = dictionary["location"] as? String
        self.notification = dictionary["notification"] as! Bool
        self.password = dictionary["password"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.photoId = dictionary["photoId"] as? String
        self.proffesion = dictionary["proffesion"] as? String
        self.school = dictionary["school"] as? String
        self.sendFeedback = dictionary["sendFeedback"] as! Bool
        self.uid = dictionary["uid"] as? String
        self.work = dictionary["work"] as? String
        self.zipcode = dictionary["zipcode"] as? String
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
