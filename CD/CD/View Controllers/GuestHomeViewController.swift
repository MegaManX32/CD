//
//  GuestHomeViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/24/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let someRequestsViewHeight: CGFloat = 122

class GuestHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var overviewLabel : UILabel!
    
    @IBOutlet weak var yourRiderListView : UIView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var riderListDetailsLabel : UILabel!
    
    @IBOutlet weak var riderListOffersView : UIView!
    @IBOutlet weak var riderListOffersViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var createRiderListView : UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var numberOfRiderListOffersLabel : UILabel!
    @IBOutlet weak var hiLabel : UILabel!
    
    var yourRiderList : RiderList?
    var riderListOffersArray = [RiderListOffer]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // prepare presentation
        self.prepareDataForPresentation()
        
        // set hi label
        let userID = StandardUserDefaults.userID()
        let user = User.findUserWith(uid: userID, context: CoreDataManager.sharedInstance.mainContext)!
        self.hiLabel.text = "Hi, " + user.firstName!
        
        // get rider list for user
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getRiderListForLoggedUser(success: { [unowned self] (riderListID) in
            let context = CoreDataManager.sharedInstance.mainContext
            self.yourRiderList = RiderList.findRiderListWith(uid: riderListID, context: context)
            self.prepareDataForPresentation()
            MBProgressHUD.hide(for: self.view, animated: true)
            }, failure: { [unowned self] (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func prepareDataForPresentation() {
        
        // present my rider list view
        if let riderList = self.yourRiderList {
            
            // prepare views for rider list and offers
            self.yourRiderListView.layer.cornerRadius = 4.0
            self.yourRiderListView.layer.borderColor = UIColor.white.cgColor
            self.yourRiderListView.layer.borderWidth = 2.0
            
            self.overviewLabel.alpha = 1
            self.yourRiderListView.alpha = 1
            self.createRiderListView.alpha = 0
            
            // set data
            let userID = StandardUserDefaults.userID()
            let user = User.findUserWith(uid: userID, context: CoreDataManager.sharedInstance.mainContext)!
            self.nameLabel.text = user.firstName
            self.countryLabel.text = user.country
            
            // prepare avatar
            self.avatarImageView.layer.cornerRadius = 43 / 2.0
            self.avatarImageView.layer.masksToBounds = true
            self.avatarImageView.layer.borderWidth = 2.0;
            self.avatarImageView.layer.borderColor = UIColor.white.cgColor
            if let photoURL = user.photoURL {
                self.avatarImageView.af_setImage(withURL: URL(string: photoURL)!)
            }
            
            // prepare details
            self.riderListDetailsLabel.text = self.yourRiderList?.details
            
            // present offers view
            if let riderListOffersSet = riderList.riderListOffers {
                self.riderListOffersArray = Array(riderListOffersSet) as! [RiderListOffer]
                
                if self.riderListOffersArray.count > 0 {
                    self.riderListOffersView.alpha = 1
                    self.riderListOffersView.layer.cornerRadius = 4.0
                    self.riderListOffersView.layer.borderColor = UIColor.white.cgColor
                    self.riderListOffersView.layer.borderWidth = 2.0
                    self.riderListOffersViewHeightConstraint.constant = CGFloat(self.riderListOffersArray.count) * GuestMenuTableViewCell.cellHeight() + someRequestsViewHeight
                    
                    let endString = (self.riderListOffersArray.count == 1) ? "!" : "s!"
                    self.numberOfRiderListOffersLabel.text = "You have \(self.riderListOffersArray.count) " + "offer" + endString
                    
                    // reload data
                    self.tableView.reloadData()
                }
                else {
                    self.riderListOffersView.alpha = 0
                }
            }
            return
        }
        
        // show no requests view
        self.overviewLabel.alpha = 0
        self.yourRiderListView.alpha = 0
        self.riderListOffersView.alpha = 0
        self.createRiderListView.alpha = 1
    }
    
    // MARK: - User Actions
    
    @IBAction func openSideMenu(sender: UIButton) {
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func createNewRiderList(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateRiderListViewController") as! CreateRiderListViewController
        self.show(controller, sender: self)
    }
    
    @IBAction func reviewRiderList(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestRiderListPreviewViewController") as! GuestRiderListPreviewViewController
        controller.riderList = self.yourRiderList!
        self.show(controller, sender: self)
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.riderListOffersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:GuestMenuTableViewCell.cellIdentifier(), for: indexPath) as! GuestMenuTableViewCell
        cell.populateCellWithRaiderListOffer(riderListOffer: riderListOffersArray[indexPath.row], isLastCell: indexPath.row == self.riderListOffersArray.count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GuestMenuTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestReviewOffersViewController") as! GuestReviewOffersViewController
        controller.riderListID = self.yourRiderList?.uid!
        controller.currentOfferIndex = indexPath.row
        controller.riderListOffersArray = self.riderListOffersArray
        self.show(controller, sender: self)
    }
}
