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
    
    // MARK: - Properties
    
    var uid : String?
    var hostUid : String?
    var travelerFullName : String?
    var travelerCity : String?
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
        
        self.uid = JSON["uid"] as? String
        self.hostUid = JSON["hostUid"] as? String
        self.travelerFullName = JSON["travelerFullName"] as? String
        self.travelerCity = JSON["travelerCity"] as? String
        self.travelerCountry = JSON["travelerCountry"] as? String
        self.travelerPictureUrl = JSON["travelerPictureUrl"] as? String
        self.riderListDetails = JSON["riderListDetails"] as? String
        self.riderListUid = JSON["riderListUid"] as? String
    }
    
    func asJSON() -> [String : Any] {
        
        var JSON = [String : Any]()
        JSON["uid"] = self.uid
        JSON["hostUid"]  = self.hostUid
        JSON["travelerFullName"] = self.travelerFullName
        JSON["travelerCity"] = self.travelerCity
        JSON["travelerCountry"] =  self.travelerCountry
        JSON["travelerPictureUrl"] = self.travelerPictureUrl
        JSON["riderListDetails"] = self.riderListDetails
        JSON["riderListUid"] = self.riderListUid
        
        return JSON;
    }
}
