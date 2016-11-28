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
    
    func getUser(userID: String, success:@escaping () -> Void, failure:@escaping (String) -> Void) {
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
                    _ = User.createOrUpdateUserWith(JSON: JSON, context: context)
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
            multipartData.append(UIImageJPEGRepresentation(photo, 1)!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
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
                        
                        let photoID = JSON["id"] as! String
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
}
