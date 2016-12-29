//
//  GuestMenuTableViewCell.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class GuestMenuTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var separatorView : UIView!
    
    @IBOutlet weak var star1ImageView : UIImageView!
    @IBOutlet weak var star2ImageView : UIImageView!
    @IBOutlet weak var star3ImageView : UIImageView!
    @IBOutlet weak var star4ImageView : UIImageView!
    @IBOutlet weak var star5ImageView : UIImageView!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 43 / 2.0
        self.avatarImageView.layer.borderWidth = 2.0;
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Helper methods
    
    func populateCellWithRaiderListOffer(riderListOffer:RiderListOffer?, isLastCell: Bool) {
        self.nameLabel.text = "Vlado"
        self.countryLabel.text = "Serbia"
        self.avatarImageView.image = nil
        self.separatorView.isHidden = isLastCell
        
        self.setStarRating(rating: 4)
    }
    
    func setStarRating(rating : Float) {
        self.star1ImageView.image = UIImage.init(named: "smallStarFull")
        self.star2ImageView.image = UIImage.init(named: "smallStarFull")
        self.star3ImageView.image = UIImage.init(named: "smallStarFull")
        self.star4ImageView.image = UIImage.init(named: "smallStarFull")
        self.star5ImageView.image = UIImage.init(named: "smallStarHalf")
    }
    
    // MARK: - Type methods
    
    class func cellIdentifier() -> String {
        return String(describing:self)
    }
    
    class func cellHeight() -> CGFloat {
        return 110
    }
}
