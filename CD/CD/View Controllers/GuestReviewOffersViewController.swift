//
//  GuestReviewOffersViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let avatarImageViewHeightAndWidth: CGFloat = 80
fileprivate let interestImageViewHeightAndWidth: CGFloat = 30

class GuestReviewOffersViewController: UIViewController {
    
    // MARK: - Properties
    
    var riderListID : String!
    var currentOfferIndex : Int!
    var riderListOffersArray : [RiderListOffer]! // there should always be an offer, if we are on this screen
    
    @IBOutlet weak var numberOfOffersLabel : UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitelLabel: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    @IBOutlet weak var star1ImageView : UIImageView!
    @IBOutlet weak var star2ImageView : UIImageView!
    @IBOutlet weak var star3ImageView : UIImageView!
    @IBOutlet weak var star4ImageView : UIImageView!
    @IBOutlet weak var star5ImageView : UIImageView!
    @IBOutlet weak var interest1ImageView : UIImageView!
    @IBOutlet weak var interest2ImageView : UIImageView!
    @IBOutlet weak var interest3ImageView : UIImageView!
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var riderListTextView : UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2.0
        
        self.setNewRiderListOffer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setNewRiderListOffer() {
        
        let riderListOffer = self.riderListOffersArray[self.currentOfferIndex]
        let context = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: riderListOffer.offerorUid!, context: context)!
        let meUser = User.findUserWith(uid: StandardUserDefaults.userID(), context: context)!
        
        // prepare text for guest
        let hasMutipleOffersEnding = self.riderListOffersArray.count > 1 ? "s!" : "!"
        self.numberOfOffersLabel.text = meUser.firstName! + ", you have " + "\(self.riderListOffersArray.count) " + "offer" + hasMutipleOffersEnding
        
        // set data
        self.titleLabel.text = user.firstName!
        self.subtitelLabel.text = user.city!
        self.subtitleLabel2.text = user.country!
        self.riderListTextView.text = riderListOffer.message
        
        // set price
        self.priceLabel.text = "Price: " + "\(riderListOffer.price)"
        
        // set photo
        if let photoURL = user.photoURL {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
        
        // set interests, there should always be 3 interests
        let interestArray = Array(user.interests!)
        var interest = interestArray[0] as! Interest
        self.interest1ImageView.image = UIImage.init(named:interest.name!.lowercased())
        interest = interestArray[1] as! Interest
        self.interest2ImageView.image = UIImage.init(named:interest.name!.lowercased())
        interest = interestArray[2] as! Interest
        self.interest3ImageView.image = UIImage.init(named:interest.name!.lowercased())
    }
    
    // MARK: - User Actions
    
    @IBAction func acceptOffer(sender: UIButton) {
        
        MBProgressHUD .showAdded(to: self.view, animated: true)
        let selectedOffer = self.riderListOffersArray[self.currentOfferIndex]
        let selectedOfferID = selectedOffer.uid!
        let selectedOfferOfferorID = selectedOffer.offerorUid!
        
        let context = CoreDataManager.sharedInstance.createScratchpadContext(onMainThread: false)
        context.perform {
            [unowned self] in
            
            // get rider list
            let riderList = RiderList.findRiderListWith(uid: self.riderListID, context: context)!
            
            // get selected offer
            let selectedOffer = RiderListOffer.findRiderListOfferWith(id: selectedOfferID, context: context)!
            
            // set selected offer
            riderList.selectedRiderListOffer = selectedOffer
            
            // update rider list with selected offer
            NetworkManager.sharedInstance.createOrUpdate(riderList: riderList, context: context, success: { [unowned self] (riderListID) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestRiderListAcceptedViewController") as! GuestRiderListAcceptedViewController
                controller.selectedOfferOfferorID = selectedOfferOfferorID
                self.show(controller, sender: self)
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: {[unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ignoreOffer(sender: UIButton) {
        UIView.transition(from: self.pageView, to: self.pageView, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finished) in
            
            // set new page
            self.currentOfferIndex = (self.currentOfferIndex + 1) % self.riderListOffersArray.count
            self.setNewRiderListOffer()
        }
    }
}
