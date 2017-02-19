//
//  HostHomeViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/24/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate let someRequestsViewHeight: CGFloat = 122

class HostHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var hostRiderListArray = [HostRiderList]()
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var hiLabel : UILabel!
    @IBOutlet weak var noRequestsView : UIView!
    @IBOutlet weak var someRequestsView : UIView!
    @IBOutlet weak var someRequestsNumberLabel : UILabel!
    @IBOutlet weak var someRequestsViewHeightConstraint : NSLayoutConstraint!
    
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
        
        // prepare hi label
        let userID = StandardUserDefaults.userID()
        let user = User.findUserWith(uid: userID, context: CoreDataManager.sharedInstance.mainContext)!
        self.hiLabel.text = "Hi, " + user.firstName!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.sharedInstance.getAllRiderListsForHost(success: { [unowned self] (hostRiderListArray) in
            self.hostRiderListArray = hostRiderListArray
            self.prepareDataForPresentation()
            MBProgressHUD.hide(for: self.view, animated: true)
        }, failure: {[unowned self] (errorMessage) in
            print(errorMessage)
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    func prepareDataForPresentation() {
        
        if (self.hostRiderListArray.count > 0) {
        
            self.noRequestsView.alpha = 0
            self.someRequestsView.alpha = 1
            
            // prepare view for some requests
            self.someRequestsView.layer.cornerRadius = 4.0
            self.someRequestsView.layer.borderColor = UIColor.white.cgColor
            self.someRequestsView.layer.borderWidth = 2.0
            self.someRequestsViewHeightConstraint.constant = CGFloat(self.hostRiderListArray.count) * HostMenuTableViewCell.cellHeight() + someRequestsViewHeight
            
            let endString = (self.hostRiderListArray.count == 1) ? "!" : "s!"
            self.someRequestsNumberLabel.text = "You have \(self.hostRiderListArray.count) " + "request" + endString
            
            // reload data
            self.tableView.reloadData()
        }
        else {
            // prepare view for no requests
            self.noRequestsView.alpha = 1
            self.someRequestsView.alpha = 0
            self.noRequestsView.layer.cornerRadius = 4.0
            self.noRequestsView.layer.borderColor = UIColor.white.cgColor
            self.noRequestsView.layer.borderWidth = 2.0
        }
    }
    
    // MARK: - User Actions
    
    @IBAction func openSideMenu(sender: UIButton) {
        self.revealViewController().revealToggle(sender)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hostRiderListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HostMenuTableViewCell.cellIdentifier(), for: indexPath) as! HostMenuTableViewCell
        cell.populateCellWithRaiderList(hostRiderList: self.hostRiderListArray[indexPath.row], isLastCell: indexPath.row == self.hostRiderListArray.count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HostMenuTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HostReviewRequestsViewController") as! HostReviewRequestsViewController
        controller.currentOfferIndex = indexPath.row
        controller.hostRiderListArray = self.hostRiderListArray
        self.show(controller, sender: self)
    }
}
