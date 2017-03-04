//
//  HostProfileViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD
import HCSStarRatingView

fileprivate let defaultShownReviews: Int = 2
fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
fileprivate let sizeOfItem = CGSize.init(width: 300, height: 220)
fileprivate let aboutViewHeight: CGFloat = 116
fileprivate let reviewViewBaseHeight: CGFloat = 66
fileprivate let offerViewsHeight: CGFloat = 250

class HostProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EditProfileViewControllerDelegate {
    
    // MARK: - Properties
    
    var userID : String!
    var presentFromMainMenu: Bool = false
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var ratingView : HCSStarRatingView!
    
    @IBOutlet weak var containerViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var aboutTextLabel : UILabel!
    @IBOutlet weak var aboutViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var seeMoreButton : UIButton!
    @IBOutlet weak var seeMoreButtonHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var reviewViewHeightConstraint : NSLayoutConstraint!
    var reviewArray = [Int]()
    var reviewsExpanded : Bool = false
    
    @IBOutlet weak var accomodationCollectionView : UICollectionView!
    @IBOutlet weak var accomodationViewHeightConstraint : NSLayoutConstraint!
    var accomodationArray = [String]()
    
    @IBOutlet weak var transportationCollectionView : UICollectionView!
    @IBOutlet weak var transportationViewHeight : NSLayoutConstraint!
    var transportationArray = [String]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // should show edit button
        self.editButton.isHidden = self.userID != StandardUserDefaults.userID()
        
        // set valid back button
        self.backButton.setImage(UIImage(named:self.presentFromMainMenu ? "menuIcon" : "backIcon"), for: .normal)
        
        // get user based on ID
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getUser(userID: self.userID, success: {[unowned self] (userID) in
            let context = CoreDataManager.sharedInstance.mainContext
            let user = User.findUserWith(uid: userID, context: context)!
            self.populateViewsWithUser(user: user)
            MBProgressHUD.hide(for: self.view, animated: true)
        }, failure: { [unowned self] (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateViewsWithUser(user : User) {
        
        // prepare text
        self.nameLabel.text = user.firstName! + " " + user.lastName!
        self.addressLabel.text = user.city! + ", " + user.country!
        self.ratingView.value = 2.8
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 130 / 2.0
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.borderWidth = 2.0
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        if let photoURL = user.photoURL {
            self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
        }
        
        // prepare about view
        self.aboutTextLabel.text = user.aboutUser
        if (self.aboutTextLabel.text == nil) {
            self.aboutViewHeightConstraint.constant = 0
        }
        else {
            self.aboutViewHeightConstraint.constant = aboutViewHeight
        }
        
        // prepare review view
        if (self.reviewArray.count == 0) {
            self.reviewViewHeightConstraint.constant = 0
        }
        else {
            let currentlyShownReviews = min(defaultShownReviews, self.reviewArray.count)
            self.reviewViewHeightConstraint.constant = reviewViewBaseHeight + CGFloat(currentlyShownReviews) * HostProfileTableViewCell.cellHeight()
            if self.reviewArray.count <= defaultShownReviews {
                self.reviewViewHeightConstraint.constant -= self.seeMoreButtonHeightConstraint.constant
                self.seeMoreButtonHeightConstraint.constant = 0
                self.seeMoreButton.isHidden = true
            }
        }
        
        // prepare service offers
        self.accomodationViewHeightConstraint.constant = 0
        self.transportationViewHeight.constant = 0
        if let serviceOffers = user.serviceOffers as? Set<ServiceOffer> {
            for serviceOffer in serviceOffers {
                if serviceOffer.photoUrlList!.count > 0 && serviceOffer.type == "transportation" {
                    self.transportationArray = serviceOffer.photoUrlList!
                    self.transportationViewHeight.constant = offerViewsHeight
                    self.transportationCollectionView.reloadData()
                }
                else {
                    if serviceOffer.photoUrlList!.count > 0 {
                        self.accomodationArray = serviceOffer.photoUrlList!
                        self.accomodationViewHeightConstraint.constant = offerViewsHeight
                        self.accomodationCollectionView.reloadData()
                    }
                }
            }
        }
        
        // update container view height
        self.containerViewHeightConstraint.constant = self.aboutViewHeightConstraint.constant + self.reviewViewHeightConstraint.constant + self.accomodationViewHeightConstraint.constant + self.transportationViewHeight.constant
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HostProfileTableViewCell.cellIdentifier(), for: indexPath) as! HostProfileTableViewCell
        cell.populateCellWithUserReview(userReview: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HostProfileTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accomodationCollectionView == collectionView ? self.accomodationArray.count : self.transportationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostProfileCollectionViewCell.cellIdentifier(), for: indexPath) as! HostProfileCollectionViewCell
        let photoURL =  self.accomodationCollectionView == collectionView ? self.accomodationArray[indexPath.row] : self.transportationArray[indexPath.row]
        cell.populateCellWith(photoURL: photoURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // right now, do nothing
    }
    
    // MARK: - User Actions
    
    @IBAction func seeMoreAction() {
        let currentlyShownReviews = self.reviewsExpanded ? defaultShownReviews : self.reviewArray.count
        
        // update constraints
        self.reviewViewHeightConstraint.constant = reviewViewBaseHeight + CGFloat(currentlyShownReviews) * HostProfileTableViewCell.cellHeight()
        self.containerViewHeightConstraint.constant = self.aboutViewHeightConstraint.constant + self.reviewViewHeightConstraint.constant + self.accomodationViewHeightConstraint.constant + self.transportationViewHeight.constant
        self.reviewsExpanded = !self.reviewsExpanded
        
        // animate change
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        controller.userID = self.userID
        controller.delegate = self
        self.show(controller, sender: self)
    }
    
    @IBAction func backAction() {
        if self.presentFromMainMenu {
             self.revealViewController().revealToggle(nil)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - EditProfileViewControllerDelegate Methods
    
    func editProfileViewControllerDidFinish(controller: EditProfileViewController) {
        let context = CoreDataManager.sharedInstance.mainContext
        let user = User.findUserWith(uid: userID, context: context)!
        self.populateViewsWithUser(user: user)
    }
}
