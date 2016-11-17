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
    
    // MARK: - User
    
    func createOrUpdate(user: User, context: NSManagedObjectContext, success:@escaping (String?) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Users", method: .post, parameters: user.asJSON(), encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                
                context.perform {
                    
                    // check if valid JSON
                    guard let JSON = response.result.value as? [String: Any]
                        else {
                            failure("JSON not valid")
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
                var errorString: String?
                if let data = response.data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                        errorString = json?.first
                    }
                }
                failure(errorString ?? "Failure without error")
            }
        }
    }
    
//    func getAllUsers()
    
    func getUser(id: String) -> User? {
        
        return nil;
    }
}
