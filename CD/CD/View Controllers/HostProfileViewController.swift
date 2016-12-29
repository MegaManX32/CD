//
//  HostProfileViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/29/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

fileprivate let reviewViewBaseHeight: CGFloat = 66
fileprivate let defaultShownReviews: Int = 2

class HostProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var star1ImageView : UIImageView!
    @IBOutlet weak var star2ImageView : UIImageView!
    @IBOutlet weak var star3ImageView : UIImageView!
    @IBOutlet weak var star4ImageView : UIImageView!
    @IBOutlet weak var star5ImageView : UIImageView!
    
    @IBOutlet weak var aboutTextLabel : UILabel!
    @IBOutlet weak var aboutViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var reviewViewHeightConstraint : NSLayoutConstraint!
    
    var reviewArray = [1, 2]
    var currentlyShownReviews : Int!
    var reviewsExpanded : Bool = false
    
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
            self.currentlyShownReviews = min(defaultShownReviews, self.reviewArray.count)
            self.reviewViewHeightConstraint.constant = reviewViewBaseHeight + CGFloat(self.currentlyShownReviews) * HostProfileTableViewCell.cellHeight()
        }
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
    
    // MARK: - User Actions
    
    @IBAction func seeMoreAction() {
        // do something fun
    }
    
    @IBAction func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
