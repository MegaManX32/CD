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
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var hiLabel : UILabel!
    @IBOutlet weak var noRequestsView : UIView!
    @IBOutlet weak var someRequestsView : UIView!
    @IBOutlet weak var someRequestsNumberLabel : UILabel!
    @IBOutlet weak var someRequestsViewHeightConstraint : NSLayoutConstraint!
    
    var requestsArray = [Any]()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // get all users first , we will need them
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        NetworkManager.sharedInstance.getAllRaiderListsForHost(hostID: StandardUserDefaults.userID(), success: {[unowned self] in
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }) {[unowned self] (errorMessage) in
//            print(errorMessage)
//            MBProgressHUD.hide(for: self.view, animated: true)
//        }

        
        self.requestsArray = [1, 2, 3, 4, 5]
        if self.requestsArray.count == 0 {
            self.noRequestsView.isHidden = false
            self.someRequestsView.isHidden = true
            
            // prepare view for no requests
            self.noRequestsView.layer.cornerRadius = 4.0
            self.noRequestsView.layer.borderColor = UIColor.white.cgColor
            self.noRequestsView.layer.borderWidth = 2.0
        }
        else {
            self.noRequestsView.isHidden = true
            self.someRequestsView.isHidden = false
            
            // prepare view for some requests
            self.someRequestsView.layer.cornerRadius = 4.0
            self.someRequestsView.layer.borderColor = UIColor.white.cgColor
            self.someRequestsView.layer.borderWidth = 2.0
            self.someRequestsViewHeightConstraint.constant = CGFloat(self.requestsArray.count) * HostMenuTableViewCell.cellHeight() + someRequestsViewHeight
            
            let endString = (self.requestsArray.count == 1) ? "!" : "s!"
            self.someRequestsNumberLabel.text = "You have \(self.requestsArray.count) " + "request" + endString
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requestsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:HostMenuTableViewCell.cellIdentifier(), for: indexPath) as! HostMenuTableViewCell
        cell.populateCellWithRaiderList(riderList: nil, isLastCell: indexPath.row == self.requestsArray.count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HostMenuTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
