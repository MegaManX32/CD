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
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2.0
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
