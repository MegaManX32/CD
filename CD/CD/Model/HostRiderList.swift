//
//  HostRiderList.swift
//  CD
//
//  Created by Vladislav Simovic on 1/5/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit

/* Important - this is not real core data object and it is never perserved in database */

class HostRiderList {
    
//    "Uid": "12b9b551-354a-425c-87f0-49e40b243085",
//    "HostUid": "84cea67a-050c-4397-b9b1-bdf39c35ed6a",
//    "TravelerFullName": "Petar Petrovic",
//    "TravelerCountry": "USA",
//    "TravelerPictureUrl": null,
//    "RiderListDetails": "Hteo bih da provedem bozicne i novogodisnje praznike u svojoj domovini..."
    
    // MARK: - Properties
    
    var uid : String?
    var hostUid : String?
    var travelerFullName : String?
    var travelerCountry : String?
    var travelerPictureUrl : String?
    var riderListDetails : String?
    var riderListUid : String?
    
    // MARK: - HostRiderList CRUD
    
    static func createOrUpdateHostRiderListWith(JSON:[String : Any]) -> HostRiderList {
        
        // fetch HostRiderList or create new one
        let hostRiderList = HostRiderList()
        hostRiderList.initWith(JSON: JSON)
        return hostRiderList
    }

    
    // MARK: - JSON serialization
    
    func initWith(JSON:[String : Any]) {
        
        self.uid = JSON["Uid"] as? String
        self.hostUid = JSON["HostUid"] as? String
        self.travelerFullName = JSON["TravelerFullName"] as? String
        self.travelerCountry = JSON["TravelerCountry"] as? String
        self.travelerPictureUrl = JSON["TravelerPictureUrl"] as? String
        self.riderListDetails = JSON["RiderListDetails"] as? String
        self.riderListUid = "4c584051-ba04-4e13-a68f-85a3f014b3e9"//JSON["RiderListUid"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["Uid"] = self.uid
        JSON["HostUid"]  = self.hostUid
        JSON["TravelerFullName"] = self.travelerFullName
        JSON["TravelerCountry"] =  self.travelerCountry
        JSON["TravelerPictureUrl"] = self.travelerPictureUrl
        JSON["RiderListDetails"] = self.riderListDetails
        JSON["RiderListUid"] = "4c584051-ba04-4e13-a68f-85a3f014b3e9"//self.riderListUid
        
        return JSON;
    }
}
