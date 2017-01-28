//
//  GuestRiderListPreviewViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 1/5/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let avatarImageViewHeightAndWidth: CGFloat = 80
fileprivate let interestImageViewHeightAndWidth: CGFloat = 30

class GuestRiderListPreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var riderList : RiderList!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitelLabel: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var interest1ImageView : UIImageView!
    @IBOutlet weak var interest2ImageView : UIImageView!
    @IBOutlet weak var interest3ImageView : UIImageView!
    
    @IBOutlet weak var bestTimeLabel : UILabel!
    @IBOutlet weak var riderListTextView : UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // populate data
        let context = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: StandardUserDefaults.userID(), context: context)!
        
        // set data
        self.titleLabel.text = user.firstName!
        self.subtitelLabel.text = user.city!
        self.subtitleLabel2.text = user.country!
        self.riderListTextView.text = self.riderList.details
        
        // set photo
        if let photoURL = user.photoURL {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
        
        // set interests, there should always be 3 interests
        let interestArray = Array(riderList.interests!)
        var interest = interestArray[0] as! Interest
        self.interest1ImageView.image = UIImage.init(named:interest.name!.lowercased())
        interest = interestArray[1] as! Interest
        self.interest2ImageView.image = UIImage.init(named:interest.name!.lowercased())
        interest = interestArray[2] as! Interest
        self.interest3ImageView.image = UIImage.init(named:interest.name!.lowercased())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
