//
//  ReviewRiderLIstViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/15/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class ReviewRiderLIstViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarPlaceholderView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitelLabel: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var pageView: UIView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // make rounded profile image
        self.avatarPlaceholderView.layer.masksToBounds = true
        self.avatarPlaceholderView.layer.cornerRadius = self.avatarPlaceholderView.frame.width / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2.0
    }
    
    // MARK - User Actions
    
    @IBAction func changeOffer(sender: UIButton) {
        UIView.transition(from: self.pageView, to: self.pageView, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finished) in
            // do nothing
        }
    }
}
