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
    
    @IBOutlet weak var interestSelectedImageView: UIImageView!
    @IBOutlet weak var interestImageView: UIImageView!
    @IBOutlet weak var interestLabel: UILabel!
    
    // MARK: - Helper methods
    
    func populateCellWithInterest(name:String, imageName:String, checked:Bool) {
        self.interestLabel.text = name
        self.interestImageView.image = UIImage.init(named:imageName)
        self.interestSelectedImageView.alpha = checked ? 1 : 0
    }
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
}
