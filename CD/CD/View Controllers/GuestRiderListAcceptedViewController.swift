//
//  GuestRiderListAcceptedViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 12/27/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class GuestRiderListAcceptedViewController: UIViewController {

    // MARK: - Properties
    
    var selectedOfferOfferorFirstName : String!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare end message
        let mainContext = CoreDataManager.sharedInstance.mainContext
        let meUser = User.findUserWith(uid: StandardUserDefaults.userID(), context: mainContext)!
        
        self.titleLabel.text = meUser.firstName! + " your Rider List is accepted, " + selectedOfferOfferorFirstName + " will be your host"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User Actions
    
    @IBAction func homeAction(sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
