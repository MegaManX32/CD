//
//  SignupInterestsCollectionViewCell.swift
//  CustomDeal
//
//  Created by Vladislav Simovic on 9/28/16.
//  Copyright © 2016 Vladislav Simovic. All rights reserved.
//

import UIKit

class SignupInterestsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var interestImageView: UIImageView?
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        print("\(String(describing:self))")
        return String(describing:self)
    }
    
}
