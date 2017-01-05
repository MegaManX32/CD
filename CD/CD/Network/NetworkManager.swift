//
//  NetworkManager.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

fileprivate let baseURL = "http://customdeal.tkn.rs/api/"

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    // MARK: - Helper methods
    
    func generalizedFailure(data: Data?, defaultErrorMessage : String = "Failure without error description", failure:(String) -> Void) -> Void {
        
        // error handling
        var errorString: String?
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                errorString = json?.first
            }
        }
        failure(errorString ?? defaultErrorMessage)
    }
    
    // MARK: - User
    
    func createOrUpdate(user: User, context: NSManagedObjectContext, success:@escaping (String?) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Users", method: .post, parameters: user.asJSON(), encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [String: Any]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    user.initWith(JSON: JSON, context: context)
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    let userID = user.uid
                    DispatchQueue.main.async {
                        success(userID)
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not update user", failure: failure)
            }
        }
    }
    
    func getAllUsers(success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Users", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var usersArray = [User]()
                    for userJSON : [String : Any] in JSON {
                        usersArray.append(User.createOrUpdateUserWith(JSON: userJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get all users", failure: failure)
            }
        }
    }
    
    func getUser(userID: String, success:@escaping (String) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Users/" + userID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [String: Any]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    let user = User.createOrUpdateUserWith(JSON: JSON, context: context)
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    let userID = user.uid
                    DispatchQueue.main.async {
                        success(userID!)
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get user", failure: failure)
            }
        }
    }
    
    // MARK: - Country and City
    
    func getAllCountries(success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Settings/country", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var countriesArray = [Country]()
                    for countryJSON : [String : Any] in JSON {
                        countriesArray.append(Country.createOrUpdateCountryWith(JSON: countryJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get countries", failure: failure)
            }
        }
    }
    
    func getAllCities(country: Country, success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Settings/city/" + country.uid!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var citiesArray = [City]()
                    for cityJSON : [String : Any] in JSON {
                        citiesArray.append(City.createOrUpdateCityWith(JSON: cityJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get cities", failure: failure)
            }
        }
    }
    
    // MARK: - Photo
    
    func upload(photo: UIImage, success:@escaping (String) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.upload(multipartFormData: { (multipartData) in
            multipartData.append(UIImageJPEGRepresentation(photo, 0.2)!, withName: "file", fileName: "photo.png", mimeType: "image/png")
        }, to: baseURL + "Upload/photo",
           encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.validate().responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        // check if valid JSON
                        guard let JSON = value as? [String: Any]
                            else {
                                DispatchQueue.main.async {
                                    failure("JSON not valid")
                                }
                                return
                        }
                        
                        let photoID = JSON["uid"] as! String
                        success(photoID)
                    case .failure:
                        
                        // error handling
                        self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not upload photo", failure: failure)
                    }
                })
                
            case .failure:
                failure("Could not encode params")
            }
        })
    }
    
    // MARK: - Interest
    
    func getAllInterests(success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Interests", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var interestsArray = [Interest]()
                    for interestJSON : [String : Any] in JSON {
                        interestsArray.append(Interest.createOrUpdateInterestWith(JSON: interestJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get interests", failure: failure)
            }
        }
    }
    
    // MARK: - Language
    
    func getAllLanguages(success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Languages", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var languageArray = [Language]()
                    for languageJSON : [String : Any] in JSON {
                        languageArray.append(Language.createOrUpdateLanguageWith(JSON: languageJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get interests", failure: failure)
            }
        }
    }
    
    // MARK: - Profession
    
    func getAllProfessions(success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Professions", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var professionArray = [Profession]()
                    for professionJSON : [String : Any] in JSON {
                        professionArray.append(Profession.createOrUpdateProfessionWith(JSON: professionJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get professions", failure: failure)
            }
        }
    }
    
    // MARK: - RiderList
    
    func createOrUpdate(riderList: RiderList, context: NSManagedObjectContext, success:@escaping (String?) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "RiderList", method: .post, parameters: riderList.asJSON(), encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [String: Any]
                        else {
//                            let errorString = String(data: response.data!, encoding: .utf8)
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update riderList with JSON
                    riderList.initWith(JSON: JSON, context: context)
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    let riderListID = riderList.uid
                    DispatchQueue.main.async {
                        success(riderListID)
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not update rider list", failure: failure)
            }
        }
    }
    
    func getRiderListForLoggedUser(success:@escaping (String) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "RiderList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [String: Any]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    let riderList = RiderList.createOrUpdateRiderListWith(JSON: JSON, context: context)
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    let riderListID = riderList.uid
                    DispatchQueue.main.async {
                        success(riderListID!)
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not get rider list for logged user", failure: failure)
            }
        }
    }
    
    func getAllRiderListsForHost(hostID: String, success:@escaping () -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "HostRiderList/" + hostID, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [[String: Any]]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update user with JSON
                    var riderListArray = [RiderList]()
                    for riderListJSON : [String : Any] in JSON {
                        riderListArray.append(RiderList.createOrUpdateRiderListWith(JSON: riderListJSON, context: context))
                    }
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    DispatchQueue.main.async {
                        success()
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not rider lists for host", failure: failure)
            }
        }
    }
    
    // MARK: - RiderListOffer
    
    func createOrUpdate(riderListOffer: RiderListOffer, context: NSManagedObjectContext, success:@escaping (String?) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "RiderListOffer/send", method: .post, parameters: riderListOffer.asJSON(), encoding: JSONEncoding.default, headers: nil).validate().responseJSON {[unowned self] (response) in
            switch response.result {
            case .success:
                
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [String: Any]
                        else {
                            DispatchQueue.main.async {
                                failure("JSON not valid")
                            }
                            return
                    }
                    
                    // update riderList with JSON
                    riderListOffer.initWith(JSON: JSON)
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    
                    // always return on main queue
                    let riderListOfferID = riderListOffer.uid
                    DispatchQueue.main.async {
                        success(riderListOfferID)
                    }
                }
            case .failure:
                
                // error handling
                self.generalizedFailure(data: response.data, defaultErrorMessage: "Could not update rider list offer", failure: failure)
            }
        }
    }
}
