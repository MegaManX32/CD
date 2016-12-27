//
//  SignupCongratulationsViewController.swift
//  CD
//
//  Created by Vladislav Simovic on 10/3/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import UIKit

class SignupCongratulationsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var subtitleLabel : UILabel!
    var userID : String!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save logged user
        StandardUserDefaults.saveUserID(userID: self.userID)
        
        // show personalized congrats message
        let mainContext = CoreDataManager.sharedInstance.mainContext
        mainContext.performAndWait {
            [unowned self] in
            
            // find user
            let user = User.findUserWith(uid: self.userID, context: mainContext)!
            
            // personalize message
            self.subtitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("%@, your profile is awesome.", comment: "your profile is awesome"), user.firstName!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions
    
    @IBAction func homeAction(sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
