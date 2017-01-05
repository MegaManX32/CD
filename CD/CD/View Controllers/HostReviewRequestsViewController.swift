//
//  HostReviewRequestsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let avatarImageViewHeightAndWidth: CGFloat = 80
fileprivate let interestImageViewHeightAndWidth: CGFloat = 30
fileprivate let riderListTextViewViewMinimumHeight: CGFloat = 95
fileprivate let containerViewMinimumHeight: CGFloat = 530

class HostReviewRequestsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var numberOfRequestsLabel : UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitelLabel: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var interest1ImageView : UIImageView!
    @IBOutlet weak var interest2ImageView : UIImageView!
    @IBOutlet weak var interest3ImageView : UIImageView!
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var bestTimeLabel : UILabel!
    @IBOutlet weak var riderListTextView : UITextView!
    @IBOutlet weak var containerViewHeightConstraint : NSLayoutConstraint!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2.0
        
//        // update container view height
//        self.view.layoutIfNeeded()
//        let sizeThatFits = self.riderListTextView.sizeThatFits(CGSize(width: self.riderListTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//        self.containerViewHeightConstraint.constant = max(containerViewMinimumHeight, containerViewMinimumHeight + sizeThatFits.height - riderListTextViewViewMinimumHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func offer(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostMakingOfferViewController") as! HostMakingOfferViewController
        self.show(controller, sender: self)
    }
    
    @IBAction func ignoreOffer(sender: UIButton) {
        UIView.transition(from: self.pageView, to: self.pageView, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finished) in
            // do nothing
        }
    }
}
