//
//  GuestReviewOffersViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let avatarImageViewHeightAndWidth: CGFloat = 80
fileprivate let interestImageViewHeightAndWidth: CGFloat = 30
fileprivate let riderListTextViewViewMinimumHeight: CGFloat = 95
fileprivate let containerViewMinimumHeight: CGFloat = 530

class GuestReviewOffersViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var numberOfOffersLabel : UILabel!
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
    
    var riderListOffersArray : [RiderListOffer]! // there should always be an offer, if we are on this creen
    
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
    
    // MARK: - Helper Methods
    
    func setNewRiderListOffer(riderListOffer : RiderListOffer) {
        let mainContext = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: riderListOffer.uid!, context: mainContext)!
    }
    
    // MARK: - User Actions
    
    @IBAction func acceptOffer(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestRiderListAcceptedViewController") as! GuestRiderListAcceptedViewController
        self.show(controller, sender: self)
    }
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ignoreOffer(sender: UIButton) {
        UIView.transition(from: self.pageView, to: self.pageView, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finished) in
            
        }
    }
}
