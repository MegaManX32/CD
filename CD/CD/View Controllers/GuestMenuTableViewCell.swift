//
//  GuestMenuTableViewCell.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import HCSStarRatingView

class GuestMenuTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var separatorView : UIView!
    @IBOutlet weak var ratingView : HCSStarRatingView!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 43 / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.borderWidth = 2.0;
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Helper methods
    
    func populateCellWithRaiderListOffer(riderListOffer:RiderListOffer, isLastCell: Bool) {
        self.nameLabel.text = riderListOffer.offerorFirstName
        self.countryLabel.text = riderListOffer.offerorCountry
        self.descriptionLabel.text = riderListOffer.message
        self.ratingView.value = 1.4
        
        // set avatar
        self.avatarImageView.image = nil
        if let photoURL = riderListOffer.offerorPhotoURL {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
   
        self.separatorView.isHidden = isLastCell
    }
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
    
    class func cellHeight() -> CGFloat {
        return 110
    }
}
