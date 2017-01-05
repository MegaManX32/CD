//
//  HostMenuTableViewCell.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class HostMenuTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var separatorView : UIView!
    
    // MARK: - Cell lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 43 / 2.0
        self.avatarImageView.layer.borderWidth = 2.0;
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Helper methods
    
    func populateCellWithRaiderList(hostRiderList: HostRiderList, isLastCell: Bool) {
        self.nameLabel.text = hostRiderList.travelerFullName
        self.countryLabel.text = hostRiderList.travelerCountry
        self.descriptionLabel.text = hostRiderList.RiderListDetails
        
        // set avatar
        if let photoURL = hostRiderList.travelerPictureUrl {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
        
        // set separator
        self.separatorView.isHidden = isLastCell
    }
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
    
    class func cellHeight() -> CGFloat {
        return 100
    }
}
