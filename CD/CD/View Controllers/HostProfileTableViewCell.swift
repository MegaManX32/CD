//
//  HostProfileTableViewCell.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class HostProfileTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    
    @IBOutlet weak var star1ImageView : UIImageView!
    @IBOutlet weak var star2ImageView : UIImageView!
    @IBOutlet weak var star3ImageView : UIImageView!
    @IBOutlet weak var star4ImageView : UIImageView!
    @IBOutlet weak var star5ImageView : UIImageView!
    
    // MARK: - Cell lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // prepare container view
        self.containerView.layer.cornerRadius = 4
        self.containerView.layer.borderWidth = 2.0;
        self.containerView.layer.borderColor = UIColor.white.cgColor
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 50 / 2.0
        self.avatarImageView.layer.borderWidth = 2.0;
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
    }

    
    // MARK: - Helper methods
    
    func populateCellWithUserReview(userReview:User?) {
        
//        self.avatarImageView.image = #imageLiteral(resourceName: "testImage")
        self.nameLabel.text = "Vlado"
        self.descriptionLabel.text = "Vlado is the best host ever"
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
        return 90
    }
}
