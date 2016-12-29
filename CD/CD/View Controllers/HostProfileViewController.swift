//
//  HostProfileViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let defaultShownReviews: Int = 2
fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
fileprivate let sizeOfItem = CGSize.init(width: 300, height: 220)
fileprivate let aboutViewHeight: CGFloat = 116
fileprivate let reviewViewBaseHeight: CGFloat = 66
fileprivate let offerViewsHeight: CGFloat = 250

class HostProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var star1ImageView : UIImageView!
    @IBOutlet weak var star2ImageView : UIImageView!
    @IBOutlet weak var star3ImageView : UIImageView!
    @IBOutlet weak var star4ImageView : UIImageView!
    @IBOutlet weak var star5ImageView : UIImageView!
    
    @IBOutlet weak var containerViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var aboutTextLabel : UILabel!
    @IBOutlet weak var aboutViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var reviewViewHeightConstraint : NSLayoutConstraint!
    var reviewArray = [1, 2]
    var currentlyShownReviews : Int!
    var reviewsExpanded : Bool = false
    
    @IBOutlet weak var accomodationCollectionView : UICollectionView!
    @IBOutlet weak var accomodationViewHeightConstraint : NSLayoutConstraint!
    var accomodationArray = [1, 2]
    
    @IBOutlet weak var transportationCollectionView : UICollectionView!
    @IBOutlet weak var transportationViewHeight : NSLayoutConstraint!
    var transportationArray = [1, 2]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare avatar
        self.avatarImageView.layer.cornerRadius = 130 / 2.0
        self.avatarImageView.layer.borderWidth = 2.0;
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.image = #imageLiteral(resourceName: "testImage")
        
        // prepare about view
        if (self.aboutTextLabel.text == nil) {
            self.aboutViewHeightConstraint.constant = 0
        }
        
        // prepare review view
        if (self.reviewArray.count == 0) {
            self.reviewViewHeightConstraint.constant = 0
        }
        else {
            self.currentlyShownReviews = self.reviewArray.count//min(defaultShownReviews, self.reviewArray.count)
            self.reviewViewHeightConstraint.constant = reviewViewBaseHeight + CGFloat(self.currentlyShownReviews) * HostProfileTableViewCell.cellHeight()
        }
        
        // prepare accomodation review
        if self.accomodationArray.count > 0 {
            self.accomodationViewHeightConstraint.constant = offerViewsHeight
        }
        else {
            self.accomodationViewHeightConstraint.constant = 0
        }
        
        // prepare transportation review
        if self.transportationArray.count > 0 {
            self.transportationViewHeight.constant = offerViewsHeight
        }
        else {
            self.transportationViewHeight.constant = 0
        }
        
        // update container view height
        self.containerViewHeightConstraint.constant = self.aboutViewHeightConstraint.constant + self.reviewViewHeightConstraint.constant + self.accomodationViewHeightConstraint.constant + self.transportationViewHeight.constant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentlyShownReviews
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
        cell.populateCellWith(serviceOffer: nil)
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
        // do something fun
    }
    
    @IBAction func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
