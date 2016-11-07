//
//  NetworkManager.swift
//  CD
//
//  Created by Vladislav Simovic on 11/2/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let baseURL = "http://customdeal.tkn.rs/api/"

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    // MARK: - User
    
    func createOrUpdate(user: User, success:@escaping (User?) -> Void, failure:@escaping (String) -> Void) {
        Alamofire.request(baseURL + "Users", method: .post, parameters: user.asJSON(), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                print ("Validation Success: \(response)")
                
                let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
                context.performAndWait {
                    
                    // create new user or update existing
                    guard let JSON = response.result.value as? [String: Any]
                        else {
                            success(nil)
                            return
                    }
                    
                    let newUser = User.createOrUpdateUserWith(JSON: JSON, context: context)
                    CoreDataManager.sharedInstance.save(scratchpadContext: context)
                    success(newUser)
                }
            case .failure:
                print ("Validation Failure \(response)")
                failure((response.result.error?.localizedDescription)!)
            }
        }
    }
    
    func getUser(id: String) -> User? {
        
        return nil;
    }
}
