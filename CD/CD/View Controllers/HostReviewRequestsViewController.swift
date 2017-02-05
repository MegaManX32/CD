//
//  HostReviewRequestsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/26/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let avatarImageViewHeightAndWidth: CGFloat = 80
fileprivate let interestImageViewHeightAndWidth: CGFloat = 30
fileprivate let riderListTextViewViewMinimumHeight: CGFloat = 95
fileprivate let containerViewMinimumHeight: CGFloat = 530

class HostReviewRequestsViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentOfferIndex : Int!
    var hostRiderListArray : [HostRiderList]!
    
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
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatarImageView.layer.cornerRadius = avatarImageViewHeightAndWidth / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2.0
        
        self.setNewHostRiderList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setNewHostRiderList() {
        
        // get current host rider list
        let hostRiderList = self.hostRiderListArray[self.currentOfferIndex]
        let riderList = RiderList.findRiderListWith(uid: hostRiderList.riderListUid!, context: CoreDataManager.sharedInstance.mainContext)
        if let riderList = riderList {
            self.presentData(hostRiderList: hostRiderList, riderList: riderList)
        }
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkManager.sharedInstance.getRiderList(riderListID: hostRiderList.riderListUid!, success: { [unowned self] (riderListID) in
                let riderList = RiderList.findRiderListWith(uid: hostRiderList.riderListUid!, context: CoreDataManager.sharedInstance.mainContext)!
                self.presentData(hostRiderList: hostRiderList, riderList: riderList)
                MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: { [unowned self] (errorMessage) in
                print(errorMessage)
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        }
    }
    
    func presentData(hostRiderList: HostRiderList, riderList : RiderList) {
        let context = CoreDataManager.sharedInstance.mainContext
        let meUser = User.findUserWith(uid: StandardUserDefaults.userID(), context: context)!

        // prepare text for guest
        let hasMutipleOffersEnding = self.hostRiderListArray.count > 1 ? "s!" : "!"
        self.numberOfRequestsLabel.text = "Hi " + meUser.firstName! + ", you have " + "\(self.hostRiderListArray.count) " + "request" + hasMutipleOffersEnding

        // set data
        self.titleLabel.text = hostRiderList.travelerFullName!
        self.subtitelLabel.text = "No City"
        self.subtitleLabel2.text = hostRiderList.travelerCountry!
        self.riderListTextView.text = riderList.details

        // set photo
        if let photoURL = hostRiderList.travelerPictureUrl {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }

        // set interests, there should always be 3 interests
//        let interestArray = Array(riderList.interests!)
//        var interest = interestArray[0] as! Interest
//        self.interest1ImageView.image = UIImage.init(named:interest.name!.lowercased())
//        interest = interestArray[1] as! Interest
//        self.interest2ImageView.image = UIImage.init(named:interest.name!.lowercased())
//        interest = interestArray[2] as! Interest
//        self.interest3ImageView.image = UIImage.init(named:interest.name!.lowercased())
    }
    
    // MARK: - User Actions
    
    @IBAction func backAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func offer(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostMakingOfferViewController") as! HostMakingOfferViewController
        controller.riderListID = self.hostRiderListArray[self.currentOfferIndex].riderListUid
        self.show(controller, sender: self)
    }
    
    @IBAction func ignoreOffer(sender: UIButton) {
        UIView.transition(from: self.pageView, to: self.pageView, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finished) in
            
            // set new page
            self.currentOfferIndex = (self.currentOfferIndex + 1) % self.hostRiderListArray.count
            self.setNewHostRiderList()
        }
    }
}
