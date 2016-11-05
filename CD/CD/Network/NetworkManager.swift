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
        Alamofire.request(baseURL + "User", method: .post, parameters: user.asJSON(), encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print ("Validation Success: \(response)")
                success(nil)
            case .failure:
                print ("Validation Failure \(response)")
                failure("some error")
            }
        }
    }
    
//    func getUser(id: String) -> User {
//        
//        return nil;
//    }
}
