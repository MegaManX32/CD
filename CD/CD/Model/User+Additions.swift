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
        JSON["birthDate"] = self.birthDate! as NSDate
        JSON["country"] = self.country! as String
        JSON["email"] = self.email! as String
        JSON["firstName"] = self.firstName! as String
        JSON["hostOption"] = self.hostOption as Bool
        JSON["lastName"] = self.lastName! as String
        JSON["location"] = self.location! as String
        JSON["notification"] = self.notification as Bool
        JSON["password"] = self.password! as String
        JSON["phoneNumber"] = self.phoneNumber! as String
        JSON["photoId"] = self.photoId! as String
        JSON["proffesion"] = self.proffesion! as String
        JSON["school"] = self.school! as String
        JSON["sendFeedback"] = self.sendFeedback as Bool
        JSON["uid"] = self.uid! as String
        JSON["work"] = self.work! as String
        JSON["zipcode"] = self.zipcode! as String
        
        // create relationships
        if let interests = self.interests {
            var interestsArray = [[String : String]]()
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
            var languagesArray = [[String : String]]()
            for language in languages {
                languagesArray.append((language as! Language).asJSON())
            }
            JSON["language"] = languagesArray
        }
        
        return JSON
    }
    
    /*
     @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
     return NSFetchRequest<User>(entityName: "User");
     }
     
     @NSManaged public var birthDate: NSDate?
     @NSManaged public var country: String?
     @NSManaged public var email: String?
     @NSManaged public var firstName: String?
     @NSManaged public var hostOption: Bool
     @NSManaged public var lastName: String?
     @NSManaged public var location: String?
     @NSManaged public var notification: Bool
     @NSManaged public var password: String?
     @NSManaged public var phoneNumber: String?
     @NSManaged public var photoId: String?
     @NSManaged public var proffesion: String?
     @NSManaged public var school: String?
     @NSManaged public var sendFeedback: Bool
     @NSManaged public var uid: String?
     @NSManaged public var work: String?
     @NSManaged public var zipcode: String?

     */
}
