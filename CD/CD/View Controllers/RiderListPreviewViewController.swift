//
//  RiderListPreviewViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let avatarImageViewHeightAndWidth: CGFloat = 80
fileprivate let interestImageViewHeightAndWidth: CGFloat = 30

class RiderListPreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitelLabel: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var interest1ImageView : UIImageView!
    @IBOutlet weak var interest2ImageView : UIImageView!
    @IBOutlet weak var interest3ImageView : UIImageView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2.0
        
        self.interest1ImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.interest1ImageView.layer.borderColor = UIColor.white.cgColor
        self.interest1ImageView.layer.borderWidth = 2.0
        
        self.interest2ImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.interest2ImageView.layer.borderColor = UIColor.white.cgColor
        self.interest2ImageView.layer.borderWidth = 2.0
        
        self.interest3ImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.interest3ImageView.layer.borderColor = UIColor.white.cgColor
        self.interest3ImageView.layer.borderWidth = 2.0
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
