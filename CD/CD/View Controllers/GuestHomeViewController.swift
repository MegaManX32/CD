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
    @IBOutlet weak var riderListOffersView : UIView!
    @IBOutlet weak var riderListOffersViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var createRiderListView : UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var numberOfRiderListOffersLabel : UILabel!
    
    var yourRiderList : RiderList?
    var riderListOffersArray = [1, 2, 4, 4 ,5]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.riderListOffersArray.count != 0 {
            self.overviewLabel.isHidden = false
            self.yourRiderListView.isHidden = false
            self.riderListOffersView.isHidden = false
            self.createRiderListView.isHidden = true
            
            // prepare views for rider list and offers
            self.yourRiderListView.layer.cornerRadius = 4.0
            self.yourRiderListView.layer.borderColor = UIColor.white.cgColor
            self.yourRiderListView.layer.borderWidth = 2.0
            
            self.riderListOffersView.layer.cornerRadius = 4.0
            self.riderListOffersView.layer.borderColor = UIColor.white.cgColor
            self.riderListOffersView.layer.borderWidth = 2.0
            self.riderListOffersViewHeightConstraint.constant = CGFloat(self.riderListOffersArray.count) * GuestMenuTableViewCell.cellHeight() + someRequestsViewHeight
            
            let endString = (self.riderListOffersArray.count == 1) ? "!" : "s!"
            self.numberOfRiderListOffersLabel.text = "You have \(self.riderListOffersArray.count) " + "offer" + endString
        }
        else {
            self.overviewLabel.isHidden = true
            self.yourRiderListView.isHidden = true
            self.riderListOffersView.isHidden = true
            self.createRiderListView.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.show(controller, sender: self)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.riderListOffersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:GuestMenuTableViewCell.cellIdentifier(), for: indexPath) as! GuestMenuTableViewCell
        cell.populateCellWithRaiderListOffer(riderListOffer: nil, isLastCell: indexPath.row == self.riderListOffersArray.count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GuestMenuTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GuestReviewOffersViewController") as! GuestReviewOffersViewController
        self.show(controller, sender: self)
    }
}
